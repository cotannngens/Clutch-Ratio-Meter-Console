//
//  BluetoothDevicesViewController+DataSource.swift
//  VKR
//
//  Created by Константин Хамицевич on 27.01.2024.
//

import UIKit
import ProgressHUD

extension BluetoothDevicesViewController {
    internal func updateStructure() {
        let cellsStructure = TableViewStructure()
        var cellModels: [BaseTableViewCellModel] = []

        blueetoothManager.availablePeripheales.forEach {
            let bluetoothDeviceModel = BluetoothDeviceTableViewCellModel(deviceName: $0.name ?? "", connectionState: $0.state)
            cellModels.append(bluetoothDeviceModel)
        }

        let cellsSection = TableViewSectionModel(cellModels: cellModels)
        cellsStructure.addSection(section: cellsSection)
        structure = cellsStructure
    }
}

extension BluetoothDevicesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let structure = structure else { return 0 }
        return tableView.numberOfSections(in: structure)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let structure = structure else { return 0 }
        return tableView.numberOfRows(in: structure, section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let structure = structure else { return UITableViewCell() }
        return tableView.dequeueReusableCell(with: structure, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let structure = structure else { return 60 }
        return structure.cellModel(for: indexPath).height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard blueetoothManager.availablePeripheales[indexPath.row] != blueetoothManager.currentPeripheral else {
            blueetoothManager.disconnectPeripheral()
            return
        }
        blueetoothManager.connectPeripheral(with: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
