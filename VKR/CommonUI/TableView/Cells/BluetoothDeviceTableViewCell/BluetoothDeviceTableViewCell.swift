//
//  BluetoothDeviceTableViewCell.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit
import SnapKit
import CoreBluetooth

final class BluetoothDeviceTableViewCell: BaseTableViewCell {
    private lazy var deviceNameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = ColorTheme.commonBlack
        view.textAlignment = .left
        view.numberOfLines = 1
        return view
    }()

    private lazy var stateImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate))
        view.tintColor = ColorTheme.green
        view.isHidden = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    private func setupView() {
        contentView.backgroundColor = ColorTheme.backgroundUpperLayer
        contentView.addSubviews(deviceNameLabel, stateImageView)

        deviceNameLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(stateImageView.snp.leading).inset(-16)
        }

        stateImageView.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

    override func updateAppearance() {
        super.updateAppearance()
        guard let model = model as? BluetoothDeviceTableViewCellModel else { return }
        setup(deviceName: model.deviceName, connectionState: model.connectionState)
    }

    func setup(deviceName: String, connectionState: CBPeripheralState) {
        deviceNameLabel.text = deviceName
        stateImageView.isHidden = connectionState != .connected
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
