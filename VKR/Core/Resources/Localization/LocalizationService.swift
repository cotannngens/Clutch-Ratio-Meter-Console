//
//  LocalizationService.swift
//  VKR
//
//  Created by Константин Хамицевич on 13.04.2024.
//

import Foundation

enum Language: String {

    case en, ru, zh, kk

    var title: String {
        switch self {
        case .en:
            return "English"
        case .ru:
            return "Русский"
        case .zh:
            return "中文"
        case .kk:
            return "Қазақ"
        }
    }

    var code: String {
        switch self {
        case .zh: return "zh-Hans"
        case .kk: return "kk-KZ"
        default: return self.rawValue
        }
    }
}

final class LocalizationService {

    static var shared = LocalizationService()

    var languages: [Language] = [.en, .ru, .zh, .kk]

    func getTranslationBy(_ key: String) -> String {
        guard let currentLanguageCode = UserDefaults.languageTranslationCode else {
            return getTranslation(key, code: "en")
        }
        return getTranslation(key, code: currentLanguageCode)
    }

    func getSystemLanguageCode() -> String? {
        return NSLocale.current.languageCode
    }

    private func getTranslation(_ key: String, code: String) -> String {
        let path = Bundle.main.path(forResource: code, ofType: "lproj")
        let bundle = Bundle(path: path ?? "")
        return bundle?.localizedString(forKey: key, value: nil, table: nil) ?? ""
    }
}
