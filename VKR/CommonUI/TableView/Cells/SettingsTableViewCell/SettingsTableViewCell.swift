//
//  SettingsTableViewCell.swift
//  VKR
//
//  Created by Константин Хамицевич on 13.04.2024.
//

import UIKit
import SnapKit

final class SettingsTableViewCell: BaseTableViewCell {
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = UIColor.commonBlack
        view.textAlignment = .left
        view.numberOfLines = 1
        return view
    }()

    private lazy var stateImageView: UIImageView = {
        UIImageView()
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    private func setupView() {
        contentView.backgroundColor = UIColor.backgroundUpperLayer
        contentView.addSubviews(titleLabel, stateImageView)

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(stateImageView.snp.leading).inset(-16)
        }

        stateImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

    override func updateAppearance() {
        super.updateAppearance()
        guard let model = model as? SettingsTableViewCellModel else { return }
        setup(title: model.title, cellType: model.cellType)
    }

    func setup(title: String, cellType: SettingsCellType) {
        titleLabel.text = title
        switch cellType {
        case .mainSection:
            stateImageView.image = Resources.Images.settingsDisclouserIcon
            stateImageView.tintColor = UIColor.gray.withAlphaComponent(0.5)
        case .language(let isSelected):
            stateImageView.image = Resources.Images.deviceConnectedIcon
            stateImageView.tintColor = UIColor.commonGreen
            stateImageView.isHidden = !isSelected
        case .chartLineColor(let isSelected, let color):
            stateImageView.image = Resources.Images.deviceConnectedIcon
            stateImageView.tintColor = UIColor.commonGreen
            stateImageView.isHidden = !isSelected
            titleLabel.textColor = color ?? .commonBlack
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
