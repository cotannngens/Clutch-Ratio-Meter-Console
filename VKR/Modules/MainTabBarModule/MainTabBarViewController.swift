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
        tabBar.backgroundColor = UIColor.backgroundUpperLayer
        tabBar.unselectedItemTintColor = UIColor.commonBlack
        tabBar.tintColor = UIColor.accent

        let bluetoothVC = BluetoothDevicesViewController()
        bluetoothVC.tabBarItem = UITabBarItem(title: "Bluetooth",
                                              image: Resources.Images.bluetoothTabBarIcon,
                                              tag: 1)
        let userLocationVC = UserLocationViewController()
        userLocationVC.tabBarItem = UITabBarItem(title: "Location",
                                            image: Resources.Images.userLocationTabBarIcon,
                                            tag: 2)
        let settingVC = UIViewController()
        settingVC.tabBarItem = UITabBarItem(title: "Settings",
                                            image: Resources.Images.settingsTabBarIcon,
                                            tag: 3)

        setViewControllers([bluetoothVC, userLocationVC, settingVC], animated: true)
        selectedIndex = UserDefaults.lastUsedDeviceId.isEmpty ? 0 : 1
    }
}
