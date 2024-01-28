//
//  Resources.swift
//  VKR
//
//  Created by Константин Хамицевич on 28.01.2024.
//

import UIKit

enum Resources {
    enum ColorTheme {
        static var accent: UIColor { return UIColor(named: "accent") ?? .black }
        static var green: UIColor { return UIColor(named: "green") ?? .black }
        static var commonBlack: UIColor { return UIColor(named: "commonBlack") ?? .black }
        static var backgroundBottomLayer: UIColor { return UIColor(named: "backgroundBottomLayer") ?? .black }
        static var backgroundUpperLayer: UIColor { return UIColor(named: "backgroundUpperLayer") ?? .black }
    }

    enum Images {
        static var bluetoothTabBarIcon = UIImage(systemName: "dot.radiowaves.left.and.right")
        static var settingsTabBarIcon = UIImage(systemName: "gearshape")
        static var deviceConnectedIcon = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate)
    }
}
