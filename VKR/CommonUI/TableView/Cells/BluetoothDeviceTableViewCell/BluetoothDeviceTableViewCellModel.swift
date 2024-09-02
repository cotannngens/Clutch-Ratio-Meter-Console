//
//  BluetoothDeviceTableViewCellModel.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import CoreBluetooth

final class BluetoothDeviceTableViewCellModel: BaseTableViewCellModel {
    override var cellIdentifier: String {
        String(describing: BluetoothDeviceTableViewCell.self)
    }

    let deviceName: String
    let connectionState: CBPeripheralState

    init(deviceName: String, connectionState: CBPeripheralState) {
        self.deviceName = deviceName
        self.connectionState = connectionState
        super.init()
    }
}
