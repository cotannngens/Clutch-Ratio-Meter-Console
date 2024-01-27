//
//  MainTabBarViewController.swift
//  VKR
//
//  Created by Константин Хамицевич on 21.01.2024.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        tabBar.clipsToBounds = false
        tabBar.backgroundColor = ColorTheme.backgroundUpperLayer
        tabBar.unselectedItemTintColor = ColorTheme.commonBlack
        tabBar.tintColor = ColorTheme.accent
        
        let bluetoothVC = BluetoothDevicesViewController()
        bluetoothVC.tabBarItem = UITabBarItem(title: "Bluetooth",
                                              image: UIImage(systemName: "dot.radiowaves.left.and.right"),
                                            tag: 1)
        let settingVC = UIViewController()
        settingVC.tabBarItem = UITabBarItem(title: "Settings",
                                              image: UIImage(systemName: "gearshape"),
                                              tag: 2)
        
        setViewControllers([bluetoothVC, settingVC], animated: true)
        selectedIndex = UserDefaults.lastUsedDeviceId.isEmpty ? 0 : 1
    }
}
