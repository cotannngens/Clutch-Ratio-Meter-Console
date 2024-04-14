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
        var cellModels: [BaseTableViewCellModel] = []

        let languageModel = SettingsTableViewCellModel(title: SettingsSection.language.title, cellType: .mainSection)
        languageModel.tapAction = { [weak self] in
            self?.presentLanguageVC()
        }
        cellModels.append(languageModel)

        let cellsSection = TableViewSectionModel(cellModels: cellModels)
        cellsStructure.addSection(section: cellsSection)
        structure = cellsStructure
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

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
