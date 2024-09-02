//
//  SettingsViewController.swift
//  VKR
//
//  Created by Константин Хамицевич on 13.04.2024.
//

import UIKit

final class SettingsViewController: UIViewController {

    internal lazy var settingsView: SettingsView = {
        let view = SettingsView()
        view.setupTableDelegate(delegate: self)
        return view
    }()

    internal var structure: TableViewStructure? {
        didSet {
            DispatchQueue.main.async {
                self.settingsView.reloadTableData()
            }
        }
    }

    override func loadView() {
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateStructure()
    }

    internal func presentLanguageVC() {
        let languageVC = LanguageViewController()
        present(languageVC, animated: true, completion: nil)
    }

    internal func presentChartLineColorVC() {
        let chartLineColorVC = ChartLineColorViewController()
        present(chartLineColorVC, animated: true, completion: nil)
    }
}
