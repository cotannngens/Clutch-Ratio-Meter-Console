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

        let measurementVC = MeasurementViewController()
        measurementVC.tabBarItem = UITabBarItem(title: "measurement_tab_bar".translate(),
                                              image: Resources.Images.measurementTabBarIcon,
                                              tag: 1)

        let bluetoothVC = BluetoothDevicesViewController()
        bluetoothVC.tabBarItem = UITabBarItem(title: "bluetooth_tab_bar".translate(),
                                              image: Resources.Images.bluetoothTabBarIcon,
                                              tag: 2)
        let userLocationVC = UserLocationViewController()
        userLocationVC.tabBarItem = UITabBarItem(title: "location_tab_bar".translate(),
                                            image: Resources.Images.userLocationTabBarIcon,
                                            tag: 3)
        let settingVC = SettingsViewController()
        settingVC.tabBarItem = UITabBarItem(title: "settings_tab_bar".translate(),
                                            image: Resources.Images.settingsTabBarIcon,
                                            tag: 4)

        setViewControllers([measurementVC, bluetoothVC, userLocationVC, settingVC], animated: true)
        selectedIndex = UserDefaults.lastUsedDeviceId.isEmpty ? 1 : 0
    }
}
