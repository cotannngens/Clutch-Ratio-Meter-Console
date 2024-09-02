//
//  SettingsTextFieldTableViewCellModel.swift
//  VKR
//
//  Created by Константин Хамицевич on 28.04.2024.
//

import Foundation

final class SettingsTextFieldTableViewCellModel: BaseTableViewCellModel {
    override var cellIdentifier: String {
        String(describing: SettingsTextFieldTableViewCell.self)
    }

    let title: String
    let value: Int
    var valueChanged: ((Int) -> Void)?

    init(title: String, value: Int, valueChanged: ((Int) -> Void)?) {
        self.title = title
        self.value = value
        self.valueChanged = valueChanged
        super.init()
    }
}
