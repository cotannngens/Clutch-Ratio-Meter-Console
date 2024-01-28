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
    private var characteristic: CBCharacteristic?
    private var manager: CBCentralManager?
    private let serviceUUID = CBUUID(string: "0xFFE0")
    private let nameIdentifier = "IKSEM#"

    var availablePeripheales = [CBPeripheral]() {
        didSet {
            shouldReloadTable?()
        }
    }

    var shouldReloadTable: (() -> Void)?
    var willStopScanning: (() -> Void)?

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
            shouldReloadTable?()
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
        shouldReloadTable?()
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Did disconnect to \(peripheral)")
        shouldReloadTable?()
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
            peripheral.discoverCharacteristics(nil, for: service)
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

    }
}

extension BluetoothManager {
    func connectPeripheral(with index: Int) {
        disconnectPeripheral()
        guard index < availablePeripheales.count else { return }
        currentPeripheral = availablePeripheales[index]
        currentPeripheral?.delegate = self
        print("Will connect to \(currentPeripheral)")
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
        manager?.scanForPeripherals(withServices: nil, options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) { [weak self] in
            self?.stopScanning()
        }
    }

    func stopScanning() {
        manager?.stopScan()
        willStopScanning?()
    }
}
