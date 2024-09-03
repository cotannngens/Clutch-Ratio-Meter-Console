//
//  LanguageViewController+DataSource.swift
//  VKR
//
//  Created by Константин Хамицевич on 13.04.2024.
//

import UIKit

extension LanguageViewController {
    internal func updateStructure() {
        let cellsStructure = TableViewStructure()
        let cellModels: [BaseTableViewCellModel] = LocalizationService.shared.languages.map { language in
            let isSelected = language.code == UserDefaults.languageTranslationCode
            let model = SettingsTableViewCellModel(title: language.title, cellType: .language(isSelected: isSelected))
            model.tapAction = { [weak self] in
                UserDefaults.languageTranslationCode = language.code
                self?.restartApp()
            }
            return model
        }

        let cellsSection = TableViewSectionModel(cellModels: cellModels)
        cellsStructure.addSection(section: cellsSection)
        structure = cellsStructure
    }
}

extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {

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
