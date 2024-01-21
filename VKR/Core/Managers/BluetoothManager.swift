//
//  BluetoothManager.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit
import CoreBluetooth

final class BluetoothManager: NSObject {
    
    static let shared = BluetoothManager()
    
    private var peripheral: CBPeripheral?
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
    
    override init() {
        super.init()
        self.manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Did discover \(peripheral)")
        if let peripheralName = peripheral.name, peripheralName.contains(nameIdentifier) {
            if !availablePeripheales.contains(peripheral) {
                availablePeripheales.append(peripheral)
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Bluetooth is switched off")
        case .poweredOn:
            print("Bluetooth is switched on")
            manager?.scanForPeripherals(withServices: nil, options: nil)
        case .unsupported:
            print("Bluetooth is not supported")
        default:
            print("Unknown state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.peripheral = nil
        characteristic = nil
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
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
}

extension BluetoothManager {
    func connectPeripheral(with index: Int) {
        guard index < availablePeripheales.count else { return }
        manager?.stopScan()
        peripheral = availablePeripheales[index]
        print("Will connect to \(peripheral)")
        peripheral?.delegate = self
        manager?.connect(peripheral!, options: nil)
    }
    
    func disconnectPeripheral() {
        guard let peripheral = peripheral else {return}
        manager?.cancelPeripheralConnection(peripheral)
    }
}
