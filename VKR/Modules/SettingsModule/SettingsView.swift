//
//  SettingsView.swift
//  VKR
//
//  Created by Константин Хамицевич on 13.04.2024.
//

import UIKit
import SnapKit

final class SettingsView: UIView {

    private lazy var settingsTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = UIColor.backgroundBottomLayer
        view.separatorStyle = .singleLine
        view.showsVerticalScrollIndicator = false
        view.registerWithType(cell: SettingsTableViewCell.self)
        view.registerWithType(cell: SettingsTextFieldTableViewCell.self)
        view.keyboardDismissMode = .onDrag
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor.backgroundBottomLayer
        addSubviews(settingsTableView)
        settingsTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func setupTableDelegate(delegate: UITableViewDelegate & UITableViewDataSource) {
        settingsTableView.dataSource = delegate
        settingsTableView.delegate = delegate
    }

    func reloadTableData() {
        settingsTableView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
