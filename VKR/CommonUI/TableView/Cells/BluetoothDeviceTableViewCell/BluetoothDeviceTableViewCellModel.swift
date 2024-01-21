//
//  BluetoothDeviceTableViewCellModel.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

final class BluetoothDeviceTableViewCellModel: BaseTableViewCellModel {
    override var cellIdentifier: String {
        String(describing: BluetoothDeviceTableViewCell.self)
    }

    let deviceName: String

    init(deviceName: String) {
        self.deviceName = deviceName
        super.init()
    }
}
