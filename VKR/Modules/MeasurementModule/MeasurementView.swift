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
        view.scaleXEnabled = true

        view.leftAxis.gridColor = UIColor.gray.withAlphaComponent(0.5)
        view.leftAxis.drawAxisLineEnabled = false
        view.leftAxis.drawLabelsEnabled = true
        view.leftAxis.axisMinimum = 0
        view.scaleYEnabled = true

        view.autoScaleMinMaxEnabled = false
        view.rightAxis.enabled = false
        view.legend.enabled = false
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
        view.text = "chart_no_data".translate()
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var measurementStateButton: CommonButton = {
        let view = CommonButton()
        view.enabledBackgroundColor = UIColor.commonGreen
        view.title = "button_start".translate()
        view.isEnabled = false
        view.addTarget(self, action: #selector(measurementButtonTapped), for: .touchUpInside)
        return view
    }()

    private lazy var sendProtocolButton: CommonButton = {
        let view = CommonButton()
        view.title = "button_share".translate()
        view.isEnabled = false
        view.addTarget(self, action: #selector(sendProtocolButtonTapped), for: .touchUpInside)
        return view
    }()

    private lazy var indicateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = UIColor.commonBlack
        view.textAlignment = .left
        view.numberOfLines = 1
        view.text = "indicate".translate()
        return view
    }()

    private lazy var indicateSwitch: UISwitch = {
        let view = UISwitch()
        view.isEnabled = false
        view.addTarget(self, action: #selector(indicate), for: .valueChanged)
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

    var isMeasurementAllowed = false {
        didSet {
            if !isMeasurementAllowed { isMeasurementActive = false }
            indicateSwitch.isEnabled = isMeasurementAllowed
            indicateLabel.textColor = indicateSwitch.isEnabled ? .commonBlack : .gray
            if isMeasurementActive {
                measurementStateButton.backgroundColor = UIColor.commonRed
            } else {
                measurementStateButton.isEnabled = isMeasurementAllowed
            }
        }
    }

    var measurementStatusChanged: ((Bool) -> Void)?
    var sendProtocolTapped: (() -> Void)?
    var indicateSwitchTapped: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
        updateChartData()
    }

    private func setupView() {
        backgroundColor = UIColor.backgroundBottomLayer
        let safeArea = safeAreaLayoutGuide

        addSubviews(
            chartView, noDataLabel, measurementStateButton,
            sendProtocolButton, indicateLabel, indicateSwitch
        )

        chartView.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }

        noDataLabel.snp.makeConstraints { make in
            make.center.equalTo(chartView)
        }

        indicateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(indicateSwitch)
            make.trailing.equalTo(indicateSwitch.snp.leading).inset(-8)
            make.leading.equalToSuperview().inset(8)
        }

        indicateSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.greaterThanOrEqualTo(chartView.snp.bottom).inset(-8)
        }

        measurementStateButton.snp.makeConstraints { make in
            make.top.equalTo(indicateSwitch.snp.bottom).inset(-16)
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        sendProtocolButton.snp.makeConstraints { make in
            make.top.equalTo(measurementStateButton.snp.bottom).inset(-16)
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(safeArea).inset(16)
        }
    }

    private func updateChartData() {
        let color = UIColor(named: UserDefaults.chartLineColor) ?? .accent
        let dataSet = LineChartDataSet(entries: Array(dataEntries.suffix(UserDefaults.chartScaleX)), label: "")
        dataSet.drawValuesEnabled = false
        dataSet.setColor(color)
        dataSet.lineWidth = 1
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        chartView.leftAxis.axisMaximum = Double(UserDefaults.chartScaleY)
        chartView.data = LineChartData(dataSet: dataSet)
        noDataLabel.isHidden = !dataEntries.isEmpty
    }

    private func updateUIWithMeasurementStatus() {
        measurementStatusChanged?(isMeasurementActive)
        measurementStateButton.title = isMeasurementActive ? "button_stop".translate() : "button_start".translate()
        if isMeasurementActive {
            dataEntries = []
            measurementStateButton.backgroundColor = UIColor.commonRed
        } else {
            measurementStateButton.isEnabled = isMeasurementAllowed
        }
        sendProtocolButton.isEnabled = !isMeasurementActive && !dataEntries.isEmpty
    }

    @objc private func measurementButtonTapped() {
        isMeasurementActive.toggle()
    }

    @objc private func sendProtocolButtonTapped() {
        sendProtocolTapped?()
    }

    @objc private func indicate() {
        indicateSwitchTapped?(indicateSwitch.isOn)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
