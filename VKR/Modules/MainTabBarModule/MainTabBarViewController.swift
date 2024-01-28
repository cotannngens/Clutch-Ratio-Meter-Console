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
        tabBar.backgroundColor = Resources.ColorTheme.backgroundUpperLayer
        tabBar.unselectedItemTintColor = Resources.ColorTheme.commonBlack
        tabBar.tintColor = Resources.ColorTheme.accent

        let bluetoothVC = BluetoothDevicesViewController()
        bluetoothVC.tabBarItem = UITabBarItem(title: "Bluetooth",
                                              image: Resources.Images.bluetoothTabBarIcon,
                                              tag: 1)
        let settingVC = UIViewController()
        settingVC.tabBarItem = UITabBarItem(title: "Settings",
                                            image: Resources.Images.settingsTabBarIcon,
                                            tag: 2)

        setViewControllers([bluetoothVC, settingVC], animated: true)
        selectedIndex = UserDefaults.lastUsedDeviceId.isEmpty ? 0 : 1
    }
}
