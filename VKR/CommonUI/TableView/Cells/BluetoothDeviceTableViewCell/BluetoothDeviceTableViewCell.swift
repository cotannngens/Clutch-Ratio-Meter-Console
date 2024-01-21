//
//  BluetoothDeviceTableViewCell.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit
import SnapKit

final class BluetoothDeviceTableViewCell: BaseTableViewCell {
    private lazy var deviceNameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = ColorTheme.commonBlack
        view.textAlignment = .center
        view.numberOfLines = 1
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    private func setupView() {
        contentView.backgroundColor = ColorTheme.backgroundUpperLayer
        contentView.addSubviews(deviceNameLabel)
        
        deviceNameLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func updateAppearance() {
        super.updateAppearance()
        guard let model = model as? BluetoothDeviceTableViewCellModel else { return }
        setup(deviceName: model.deviceName)
    }
    
    func setup(deviceName: String) {
        deviceNameLabel.text = deviceName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
