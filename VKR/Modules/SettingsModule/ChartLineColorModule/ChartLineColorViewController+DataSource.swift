//
//  ChartLineColorViewController+DataSource.swift
//  VKR
//
//  Created by Константин Хамицевич on 28.04.2024.
//

import UIKit

extension ChartLineColorViewController {
    internal func updateStructure() {
        let cellsStructure = TableViewStructure()
        let colors: [(String, String)] = [
            ("accent", "color_orange".translate()),
            ("commonRed", "color_red".translate()),
            ("commonGreen", "color_green".translate()),
            ("commonBlack", "color_systemBlack".translate())
        ]
        let cellModels: [BaseTableViewCellModel] = colors.map { color in
            let isSelected = UserDefaults.chartLineColor == color.0
            let model = SettingsTableViewCellModel(title: color.1, cellType: .chartLineColor(isSelected: isSelected, color: UIColor(named: color.0)))
            model.tapAction = { [weak self] in
                UserDefaults.chartLineColor = color.0
                self?.updateStructure()
            }
            return model
        }

        let cellsSection = TableViewSectionModel(cellModels: cellModels)
        cellsStructure.addSection(section: cellsSection)
        structure = cellsStructure
    }
}

extension ChartLineColorViewController: UITableViewDelegate, UITableViewDataSource {

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

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
