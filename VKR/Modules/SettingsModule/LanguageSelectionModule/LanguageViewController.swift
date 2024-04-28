//
//  LanguageViewController.swift
//  VKR
//
//  Created by Константин Хамицевич on 13.04.2024.
//

import UIKit

final class LanguageViewController: UIViewController {

    internal lazy var languageView: LanguageView = {
        let view = LanguageView()
        view.setupTableDelegate(delegate: self)
        return view
    }()

    internal var structure: TableViewStructure? {
        didSet {
            DispatchQueue.main.async {
                self.languageView.reloadTableData()
            }
        }
    }

    override func loadView() {
        view = languageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateStructure()
    }

    internal func restartApp() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
        window.rootViewController = MainTabBarViewController()
    }
}
