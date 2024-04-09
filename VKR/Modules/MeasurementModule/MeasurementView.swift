//
//  MeasurementView.swift
//  VKR
//
//  Created by Константин Хамицевич on 23.03.2024.
//

import UIKit
import DGCharts
import SnapKit

final class MeasurementView: UIView {

    private lazy var chartView: LineChartView = {
        let view = LineChartView()
        view.xAxis.gridColor = UIColor.gray.withAlphaComponent(0.5)
        view.xAxis.drawAxisLineEnabled = false
        view.xAxis.drawLabelsEnabled = false

        view.leftAxis.gridColor = UIColor.gray.withAlphaComponent(0.5)
        view.leftAxis.drawAxisLineEnabled = false
        view.leftAxis.drawLabelsEnabled = false

        view.rightAxis.enabled = false
        view.legend.enabled = false
        view.autoScaleMinMaxEnabled = true
        view.scaleYEnabled = false
        view.doubleTapToZoomEnabled = true
        view.highlightPerTapEnabled = false
        view.highlightPerDragEnabled = false

        view.drawBordersEnabled = true
        view.borderLineWidth = 1
        view.borderColor = UIColor.gray.withAlphaComponent(0.5)
        view.drawGridBackgroundEnabled = true
        view.gridBackgroundColor = UIColor.backgroundUpperLayer
        return view
    }()

    private lazy var noDataLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textAlignment = .center
        view.textColor = UIColor.gray
        view.numberOfLines = 1
        view.text = "No data available yet"
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var measurementStateButton: CommonButton = {
        let view = CommonButton()
        view.backgroundColor = UIColor.commonGreen
        view.title = "Start"
        view.isEnabled = false
        view.addTarget(self, action: #selector(measurementbuttonTapped), for: .touchUpInside)
        return view
    }()

    private var isMeasurementActive = false {
        didSet {
            updateUIWithMeasurementStatus()
        }
    }

    var dataEntries: [ChartDataEntry] = [] {
        didSet {
            updateChartData()
        }
    }

    var measurementAllowed = false {
        didSet {
            measurementStateButton.isEnabled = measurementAllowed
            if !measurementAllowed { measurementAllowed = false }
        }
    }

    var measurementStatusChanged: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
        updateChartData()
    }

    private func setupView() {
        backgroundColor = UIColor.backgroundBottomLayer
        let safeArea = safeAreaLayoutGuide

        addSubviews(chartView, noDataLabel, measurementStateButton)
        chartView.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }

        noDataLabel.snp.makeConstraints { make in
            make.center.equalTo(chartView)
        }

        measurementStateButton.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).inset(-8)
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }

    private func updateChartData() {
        let dataSet = LineChartDataSet(entries: Array(dataEntries.suffix(100)), label: "")
        dataSet.drawValuesEnabled = false
        dataSet.setColor(UIColor.accent)
        dataSet.lineWidth = 1
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        chartView.data = LineChartData(dataSet: dataSet)
        noDataLabel.isHidden = !dataEntries.isEmpty
    }

    private func updateUIWithMeasurementStatus() {
        dataEntries = []
        measurementStatusChanged?(isMeasurementActive)
        measurementStateButton.title = isMeasurementActive ? "Stop" : "Start"
        measurementStateButton.backgroundColor = isMeasurementActive ? UIColor.commonRed : UIColor.commonGreen
    }

    @objc private func measurementbuttonTapped() {
        isMeasurementActive.toggle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
