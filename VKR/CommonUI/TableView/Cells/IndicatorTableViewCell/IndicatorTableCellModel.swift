//
//  IndicatorTableCellModel.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import Foundation

final class IndicatorTableСellModel: BaseTableViewCellModel {
    override var cellIdentifier: String {
        String(describing: IndicatorTableСell.self)
    }
    
    init() {
        super.init()
    }
}
