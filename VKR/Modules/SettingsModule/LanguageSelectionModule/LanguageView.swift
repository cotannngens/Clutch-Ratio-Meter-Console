//
//  LanguageView.swift
//  VKR
//
//  Created by Константин Хамицевич on 13.04.2024.
//

import UIKit
import SnapKit

final class LanguageView: UIView {

    private lazy var languageTableView: UITableView = {
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
        addSubviews(languageTableView)
        languageTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func setupTableDelegate(delegate: UITableViewDelegate & UITableViewDataSource) {
        languageTableView.dataSource = delegate
        languageTableView.delegate = delegate
    }

    func reloadTableData() {
        languageTableView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
