//
//  MeasurementViewController.swift
//  VKR
//
//  Created by Константин Хамицевич on 23.03.2024.
//

import UIKit
import DGCharts

final class MeasurementViewController: UIViewController {

    private lazy var measurementView: MeasurementView = {
        let view = MeasurementView()
        view.measurementStatusChanged = { [weak self] isActive in
            self?.measurementModel.chartOffsetX = 0
            self?.measurementModel.isMeasurementActive = isActive
        }
        return view
    }()

    private var measurementModel = MeasurementModel()
    private let blueetoothManager = BluetoothManager.shared

    override func loadView() {
        view = measurementView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {
        blueetoothManager.dataRecieved = { [weak self] in
            guard let self = self, self.measurementModel.isMeasurementActive else { return }
            self.updateChart()
        }

        blueetoothManager.peripheralStatusChanged = { [weak self] in
            self?.measurementView.measurementAllowed = self?.blueetoothManager.currentPeripheral != nil
        }
    }

    private func updateChart() {
        guard let force = blueetoothManager.outputDataModel.force else { return }
        measurementModel.chartOffsetX += 1
        let dataEntry = ChartDataEntry(x: measurementModel.chartOffsetX, y: Double(force))
        measurementView.dataEntries.append(dataEntry)
    }
}
