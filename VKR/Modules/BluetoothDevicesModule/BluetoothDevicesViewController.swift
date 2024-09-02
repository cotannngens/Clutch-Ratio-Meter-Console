//
//  BluetoothDevicesViewController.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit

final class BluetoothDevicesViewController: UIViewController {

    internal lazy var bluetoothDevicesView: BluetoothDevicesView = {
        let view = BluetoothDevicesView()
        view.refreshAction = { [weak self] in
            self?.blueetoothManager.scanForDevices()
        }
        view.setupTableDelegate(delegate: self)
        return view
    }()

    internal var structure: TableViewStructure? {
        didSet {
            DispatchQueue.main.async {
                self.bluetoothDevicesView.reloadTableData()
            }
        }
    }

    internal let blueetoothManager = BluetoothManager.shared

    override func loadView() {
        view = bluetoothDevicesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateStructure()
        bind()
    }

    private func bind() {
        blueetoothManager.peripheralStatusChanged = { [weak self] in
            self?.updateStructure()
        }

        blueetoothManager.willStopScanning = { [weak self] in
            self?.bluetoothDevicesView.endRefreshing()
        }
    }
}
