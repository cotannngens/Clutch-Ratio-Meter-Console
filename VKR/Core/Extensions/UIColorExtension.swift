//
//  UIColorExtension.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit

enum ColorTheme {
    static var commonBlack: UIColor { return UIColor(named: "commonBlack") ?? .black }
    static var accent: UIColor { return UIColor(named: "accent") ?? .black }
    static var backgroundBottomLayer: UIColor { return UIColor(named: "backgroundBottomLayer") ?? .black }
    static var backgroundUpperLayer: UIColor { return UIColor(named: "backgroundUpperLayer") ?? .black }
}
