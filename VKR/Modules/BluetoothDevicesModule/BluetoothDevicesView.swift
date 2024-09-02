//
//  BluetoothDevicesView.swift
//  VKR
//
//  Created by Константин Хамицевич on 09.04.2024.
//

import UIKit
import SnapKit

final class BluetoothDevicesView: UIView {

    private lazy var bluetoothDevicesTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = UIColor.backgroundBottomLayer
        view.separatorStyle = .singleLine
        view.showsVerticalScrollIndicator = false
        view.refreshControl = refreshControl
        view.registerWithType(cell: BluetoothDeviceTableViewCell.self)
        return view
    }()

    private lazy var noDevicesLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textAlignment = .center
        view.textColor = UIColor.gray
        view.numberOfLines = 1
        view.text = "no_devices".translate()
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        return refreshControl
    }()

    var refreshAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor.backgroundBottomLayer
        let safeArea = safeAreaLayoutGuide

        addSubviews(bluetoothDevicesTableView, noDevicesLabel)
        bluetoothDevicesTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        noDevicesLabel.snp.makeConstraints { $0.center.equalTo(safeArea) }
    }

    func setupTableDelegate(delegate: UITableViewDelegate & UITableViewDataSource) {
        bluetoothDevicesTableView.dataSource = delegate
        bluetoothDevicesTableView.delegate = delegate
    }

    func reloadTableData() {
        bluetoothDevicesTableView.reloadData()
    }

    func updateNoDevicesLabelVisability(_ isHidden: Bool) {
        noDevicesLabel.isHidden = isHidden
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

    @objc private func refreshControlAction() {
        refreshAction?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
