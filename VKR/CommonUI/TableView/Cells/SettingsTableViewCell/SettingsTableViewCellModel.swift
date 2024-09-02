//
//  SettingsTableViewCellModel.swift
//  VKR
//
//  Created by Константин Хамицевич on 13.04.2024.
//

import UIKit

enum SettingsCellType {
    case mainSection
    case language(isSelected: Bool)
    case chartLineColor(isSelected: Bool, color: UIColor?)
}

final class SettingsTableViewCellModel: BaseTableViewCellModel {
    override var cellIdentifier: String {
        String(describing: SettingsTableViewCell.self)
    }

    let title: String
    let cellType: SettingsCellType

    init(title: String, cellType: SettingsCellType) {
        self.title = title
        self.cellType = cellType
        super.init()
    }
}
