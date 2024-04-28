//
//  UserDefaultsExtension.swift
//  VKR
//
//  Created by Константин Хамицевич on 27.01.2024.
//

import Foundation
import UIKit

extension UserDefaults {

    enum Keys: String, CaseIterable {
        case lastUsedDeviceId
        case languageTranslationCode
        case chartLineColor
    }

    static var lastUsedDeviceId: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.lastUsedDeviceId.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lastUsedDeviceId.rawValue)
        }
    }

    static var languageTranslationCode: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.languageTranslationCode.rawValue) ?? LocalizationService.shared.getSystemLanguageCode()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.languageTranslationCode.rawValue)
        }
    }

    static var chartLineColor: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.chartLineColor.rawValue) ?? "accent"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.chartLineColor.rawValue)
        }
    }
}
