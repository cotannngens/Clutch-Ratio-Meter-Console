//
//  BluetoothDevicesViewController.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit

final class BluetoothDevicesViewController: UIViewController {

    private lazy var bluetoothDevicesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = UIColor.backgroundBottomLayer
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = refreshControl
        tableView.registerWithType(cell: BluetoothDeviceTableViewCell.self)
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshDevices), for: .valueChanged)
        return refreshControl
    }()

    internal var structure: TableViewStructure? {
        didSet {
            DispatchQueue.main.async {
                self.bluetoothDevicesTableView.reloadData()
            }
        }
    }

    internal let blueetoothManager = BluetoothManager.shared

    override func loadView() {
        view = bluetoothDevicesTableView
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
            self?.refreshControl.endRefreshing()
        }
    }

    @objc private func refreshDevices() {
        blueetoothManager.scanForDevices()
    }
}
