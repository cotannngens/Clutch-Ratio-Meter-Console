//
//  BluetoothDevicesViewController.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit

class BluetoothDevicesViewController: UIViewController {
    
    private lazy var bluetoothDevicesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = ColorTheme.backgroundBottomLayer
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.registerWithType(cell: BluetoothDeviceTableViewCell.self)
        return tableView
    }()
    
    internal var structure: TableViewStructure? {
        didSet {
            DispatchQueue.main.async {
                self.bluetoothDevicesTableView.reloadData()
            }
        }
    }
    
    private let blueetoothManager = BluetoothManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        updateStructure()
        blueetoothManager.shouldReloadTable = { [weak self] in
            self?.updateStructure()
        }
    }

    private func setupView() {
        view.backgroundColor = ColorTheme.backgroundBottomLayer
        view.addSubview(bluetoothDevicesTableView)
        bluetoothDevicesTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func updateStructure() {
        let cellsStructure = TableViewStructure()
        var cellModels: [BaseTableViewCellModel] = []
        
        blueetoothManager.availablePeripheales.forEach {
            let bluetoothDeviceModel = BluetoothDeviceTableViewCellModel(deviceName: $0.name ?? "")
            cellModels.append(bluetoothDeviceModel)
        }
        
        var cellsSection = TableViewSectionModel(cellModels: cellModels)
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
        blueetoothManager.connectPeripheral(with: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
