//
//  UserDefaultsExtension.swift
//  VKR
//
//  Created by Константин Хамицевич on 27.01.2024.
//

import Foundation

extension UserDefaults {
    
    enum Keys: String, CaseIterable {
        case lastUsedDeviceId
    }
    
    static var lastUsedDeviceId: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.lastUsedDeviceId.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lastUsedDeviceId.rawValue)
        }
    }
}
