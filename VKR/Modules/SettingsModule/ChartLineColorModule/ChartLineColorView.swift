//
//  ChartLineColorView.swift
//  VKR
//
//  Created by Константин Хамицевич on 28.04.2024.
//

import UIKit
import SnapKit

final class ChartLineColorView: UIView {

    private lazy var chartLineColorTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = UIColor.backgroundBottomLayer
        view.separatorStyle = .singleLine
        view.showsVerticalScrollIndicator = false
        view.registerWithType(cell: SettingsTableViewCell.self)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor.backgroundBottomLayer
        addSubviews(chartLineColorTableView)
        chartLineColorTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func setupTableDelegate(delegate: UITableViewDelegate & UITableViewDataSource) {
        chartLineColorTableView.dataSource = delegate
        chartLineColorTableView.delegate = delegate
    }

    func reloadTableData() {
        chartLineColorTableView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
