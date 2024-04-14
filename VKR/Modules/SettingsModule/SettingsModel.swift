//
//  SettingsModel.swift
//  VKR
//
//  Created by Константин Хамицевич on 13.04.2024.
//

import Foundation

enum SettingsSection {
    case language

    var title: String {
        switch self {
        case .language: return "language".translate()
        }
    }
}
