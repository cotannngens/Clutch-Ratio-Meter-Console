//
//  MeasurementViewController.swift
//  VKR
//
//  Created by Константин Хамицевич on 23.03.2024.
//

import UIKit
import DGCharts
import ProgressHUD

final class MeasurementViewController: UIViewController {

    private lazy var measurementView: MeasurementView = {
        let view = MeasurementView()
        view.measurementStatusChanged = { [weak self] isActive in
            self?.measurementModel.chartOffsetX = 0
            self?.measurementModel.isMeasurementActive = isActive
            isActive ? self?.measurementModel.dataProtocol = [] : nil
            self?.blueetoothManager.isMeasurementActive = isActive
        }
        view.sendProtocolTapped = { [weak self] in
            self?.shareProtocol()
        }
        view.indicateSwitchTapped = { [weak self] isIndicating in
            self?.blueetoothManager.indicate(isIndicating)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        toggleMeasurementAllowed()
    }

    private func bind() {
        blueetoothManager.dataRecieved = { [weak self] in
            guard let self = self else { return }
            self.measurementView.batteryCharge = Float(self.blueetoothManager.outputDataModel.battery ?? 0)
            guard self.measurementModel.isMeasurementActive else { return }
            self.updateChart()
            self.fillDataProtocol()
        }

        blueetoothManager.peripheralStatusChanged = { [weak self] in
            self?.toggleMeasurementAllowed()
        }
    }
}

extension MeasurementViewController {
    private func toggleMeasurementAllowed() {
        measurementView.isMeasurementAllowed = blueetoothManager.currentPeripheral != nil
        if blueetoothManager.currentPeripheral == nil { measurementView.batteryCharge = 0 }
    }

    private func updateChart() {
        guard let frictionCoeff = blueetoothManager.outputDataModel.force else { return }
        measurementModel.chartOffsetX += 1
        let dataEntry = ChartDataEntry(x: measurementModel.chartOffsetX, y: Double(frictionCoeff))
        measurementView.dataEntries.append(dataEntry)
    }

    private func fillDataProtocol() {
        let frictionCoeff = blueetoothManager.outputDataModel.frictionCoeff ?? 0
        let speed = blueetoothManager.outputDataModel.measuringWheelSpeed ?? 0
        let date = getCurrentDate()
        let latitudeString = blueetoothManager.outputDataModel.latitudeString ?? ""
        let longitudeString = blueetoothManager.outputDataModel.longitudeString ?? ""
        measurementModel.dataProtocol.append("\(frictionCoeff) \(speed) \(date) \(latitudeString) \(longitudeString)")
    }

    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
}

extension MeasurementViewController {

    private func shareProtocol() {
        let currentPeripheralName = blueetoothManager.currentPeripheral?.name ?? "Undefined"
        let protocolFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("protocol-\(currentPeripheralName).txt")
        do {
            try measurementModel.dataProtocol.joined(separator: "\n").write(to: protocolFileURL, atomically: true, encoding: .utf8)
            showActivityVC(protocolFileURL)
        } catch {
            ProgressHUD.failed("Error creating protocl", interaction: true, delay: 1)
        }
    }

    private func showActivityVC(_ fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(activityViewController, animated: true, completion: nil)
    }
}
