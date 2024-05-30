//
//  SettingsViewController+DataSource.swift
//  VKR
//
//  Created by Константин Хамицевич on 13.04.2024.
//

import UIKit

extension SettingsViewController {
    internal func updateStructure() {
        let cellsStructure = TableViewStructure()
        addSystemSection(cellsStructure)
        addChartSection(cellsStructure)
        structure = cellsStructure
    }

    private func addSystemSection(_ cellsStructure: TableViewStructure) {
        let languageModel = SettingsTableViewCellModel(title: "language".translate(), cellType: .mainSection)
        languageModel.tapAction = { [weak self] in
            self?.presentLanguageVC()
        }
        let systemCellsSection = TableViewSectionModel(cellModels: [languageModel])
        cellsStructure.addSection(section: systemCellsSection)
    }

    private func addChartSection(_ cellsStructure: TableViewStructure) {
        var chartCellModels: [BaseTableViewCellModel] = []

        let chartLineColorModel = SettingsTableViewCellModel(title: "chart_line_color".translate(), cellType: .mainSection)
        chartLineColorModel.tapAction = { [weak self] in
            self?.presentChartLineColorVC()
        }
        chartCellModels.append(chartLineColorModel)

        let chartScaleYModel = SettingsTextFieldTableViewCellModel(title: "scale_y".translate(), value: UserDefaults.chartScaleY) { [weak self] value in
            UserDefaults.chartScaleY = value
            self?.updateStructure()
        }
        chartCellModels.append(chartScaleYModel)

        let chartScaleXModel = SettingsTextFieldTableViewCellModel(title: "scale_x".translate(), value: UserDefaults.chartScaleX) { [weak self] value in
            UserDefaults.chartScaleX = value
            self?.updateStructure()
        }
        chartCellModels.append(chartScaleXModel)

        let chartCellsSection = TableViewSectionModel(cellModels: chartCellModels)
        cellsStructure.addSection(section: chartCellsSection)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

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
}
