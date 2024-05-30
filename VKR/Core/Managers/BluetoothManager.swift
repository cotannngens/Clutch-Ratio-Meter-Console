//
//  BluetoothManager.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit
import CoreBluetooth
import ProgressHUD

final class BluetoothManager: NSObject {

    static let shared = BluetoothManager()

    var currentPeripheral: CBPeripheral?
    var outputDataModel = OutputDataModel()
    var isMeasurementActive = false {
        didSet {
            if isMeasurementActive { outputDataModel.locationCoordinates = [] }
        }
    }
    private var characteristic: CBCharacteristic?
    private var manager: CBCentralManager?
    private let serviceUUID = CBUUID(string: "0xFFE0")
    private let nameIdentifier = "IKSEM#"

    var availablePeripheales = [CBPeripheral]() {
        didSet {
            peripheralStatusChanged?()
        }
    }

    var peripheralStatusChanged: (() -> Void)?
    var willStopScanning: (() -> Void)?
    var dataRecieved: (() -> Void)?

    func indicate(_ isIndicating: Bool) {
        guard let currentPeripheral = self.currentPeripheral,
              let writeCharacteristic = currentPeripheral.services?.compactMap({ $0.characteristics?.first(where: { $0.properties.contains(.writeWithoutResponse) }) }).first else {
            return
        }
        currentPeripheral.writeValue(Data([UInt8(isIndicating ? 252 : 253)]), for: writeCharacteristic, type: .withoutResponse)
    }

    override init() {
        super.init()
        self.manager = CBCentralManager(delegate: self, queue: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BluetoothManager: CBCentralManagerDelegate {

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Did discover \(peripheral)")

        if let peripheralName = peripheral.name, peripheralName.contains(nameIdentifier), !availablePeripheales.contains(peripheral) {
            availablePeripheales.append(peripheral)

            guard let lastUsedPeriphealeIndex = availablePeripheales.firstIndex(where: { $0.identifier.uuidString == UserDefaults.lastUsedDeviceId }), currentPeripheral == nil else { return }
            connectPeripheral(with: lastUsedPeriphealeIndex)
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Bluetooth is switched off")
            disconnectPeripheral(shouldForgetLastDevice: false)
            availablePeripheales = []
            peripheralStatusChanged?()
        case .poweredOn:
            print("Bluetooth is switched on")
            scanForDevices()
        case .unsupported:
            print("Bluetooth is not supported")
        default:
            print("Unknown state")
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Did connect to \(peripheral)")
        peripheral.discoverServices([serviceUUID])
        UserDefaults.lastUsedDeviceId = peripheral.identifier.uuidString
        peripheralStatusChanged?()
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Did disconnect to \(peripheral)")
        peripheralStatusChanged?()
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
        ProgressHUD.failed("Failed to connect \(peripheral.name ?? "")", interaction: true, delay: 1.0)
    }
}

extension BluetoothManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics([CBUUID(string: "0xFFE1")], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        characteristic = characteristics[0]
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let data = [UInt8](characteristic.value!)
        if data.count == 20 {
            outputDataModel.drivingWheelSpeed = (Float(data[1]) * 100 + Float(data[2])) / 10.0
            outputDataModel.measuringWheelSpeed = (Float(data[3]) * 100 + Float(data[4])) / 10.0
            outputDataModel.frictionCoeff = (Float(data[5]) * 100 + Float(data[6])) / 1000.0
            outputDataModel.force = (Float(data[7]) * 100 + Float(data[8])) / 100.0
            outputDataModel.current = (Float(data[9]) * 100 + Float(data[10])) / 10.0
            outputDataModel.temperature = data[11] - 50
            outputDataModel.gpsMode = GpsMode(rawValue: data[12])
            outputDataModel.latitudeDeg = Int(data[13])
            outputDataModel.latitudeMin = Float(data[14])
            outputDataModel.latitudeMinFraq = Float(data[15]) * 100 + Float(data[16])
            outputDataModel.longitudeDeg = Int(data[17])
            outputDataModel.longitudeMin = Float(data[18])
            outputDataModel.longitudeMinFraq = Float(data[19]) * 100
        } else if data.count == 6 {
            if let longitudeMinFraq = outputDataModel.longitudeMinFraq {
                outputDataModel.longitudeMinFraq = longitudeMinFraq + Float(data[0])
            }
            outputDataModel.latitudeLetter = data[1]
            outputDataModel.longitudeLetter = data[2]
            outputDataModel.battery = data[3]
            if let latitudeDeg = outputDataModel.latitudeDeg,
               let latitudeMin = outputDataModel.latitudeMin,
               let latitudeMinFraq = outputDataModel.latitudeMinFraq,
               let latitudeLetter = outputDataModel.latitudeLetter,
               let longitudeDeg = outputDataModel.longitudeDeg,
               let longitudeMin = outputDataModel.longitudeMin,
               let longitudeMinFraq = outputDataModel.longitudeMinFraq,
               let longitudeLetter = outputDataModel.longitudeLetter, isMeasurementActive {
                let latitudeString = "\(latitudeDeg) \(latitudeMin + latitudeMinFraq) \(latitudeLetter)"
                outputDataModel.latitudeString = latitudeString
                let longitudeString = "\(longitudeDeg) \(longitudeMin + longitudeMinFraq) \(longitudeLetter)"
                outputDataModel.longitudeString = longitudeString
                outputDataModel.locationCoordinates.append((latitudeString, longitudeString))
            }
            dataRecieved?()
        }
    }
}

extension BluetoothManager {

    func connectPeripheral(with index: Int) {
        disconnectPeripheral()
        guard index < availablePeripheales.count else { return }
        currentPeripheral = availablePeripheales[index]
        currentPeripheral?.delegate = self
        print("Will connect to \(String(describing: currentPeripheral))")
        manager?.connect(currentPeripheral!, options: nil)
    }

    func disconnectPeripheral(shouldForgetLastDevice: Bool = true) {
        guard let peripheral = currentPeripheral else {return}
        manager?.cancelPeripheralConnection(peripheral)
        currentPeripheral = nil
        characteristic = nil
        UserDefaults.lastUsedDeviceId = shouldForgetLastDevice ? "" : UserDefaults.lastUsedDeviceId
    }

    func scanForDevices() {
        manager?.stopScan()
        availablePeripheales = []
        manager?.scanForPeripherals(withServices: nil, options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            self?.stopScanning()
        }
    }

    func stopScanning() {
        manager?.stopScan()
        willStopScanning?()
    }
}
