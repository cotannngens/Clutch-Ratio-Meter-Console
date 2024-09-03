//
//  ChartLineColorViewController.swift
//  VKR
//
//  Created by Константин Хамицевич on 28.04.2024.
//

import UIKit

final class ChartLineColorViewController: UIViewController {

    internal lazy var chartLineColorView: ChartLineColorView = {
        let view = ChartLineColorView()
        view.setupTableDelegate(delegate: self)
        return view
    }()

    internal var structure: TableViewStructure? {
        didSet {
            DispatchQueue.main.async {
                self.chartLineColorView.reloadTableData()
            }
        }
    }

    override func loadView() {
        view = chartLineColorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateStructure()
    }
}
