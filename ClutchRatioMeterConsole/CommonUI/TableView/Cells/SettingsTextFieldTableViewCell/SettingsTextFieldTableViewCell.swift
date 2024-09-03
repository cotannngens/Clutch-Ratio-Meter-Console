//
//  SettingsTextFieldTableViewCell.swift
//  VKR
//
//  Created by Константин Хамицевич on 28.04.2024.
//

import UIKit
import SnapKit

final class SettingsTextFieldTableViewCell: BaseTableViewCell {
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = UIColor.commonBlack
        view.textAlignment = .left
        view.numberOfLines = 1
        return view
    }()

    private lazy var textField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .backgroundThirdLayer
        view.textColor = .commonBlack
        view.font = UIFont.systemFont(ofSize: 16)
        view.leftViewMode = .always
        view.leftView = UIView(frame: .init(x: 0, y: 0, width: 8, height: 26))
        view.rightViewMode = .always
        view.rightView = UIView(frame: .init(x: 0, y: 0, width: 8, height: 26))
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.delegate = self
        view.tintColor = .accent
        view.keyboardType = .numberPad
        view.textAlignment = .right
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    private func setupView() {
        contentView.backgroundColor = UIColor.backgroundUpperLayer
        contentView.addSubviews(titleLabel, textField)

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(textField.snp.leading).inset(-16)
        }

        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(55)
        }
    }

    override func updateAppearance() {
        super.updateAppearance()
        guard let model = model as? SettingsTextFieldTableViewCellModel else { return }
        setup(title: model.title, value: model.value)
    }

    func setup(title: String, value: Int) {
        titleLabel.text = title
        textField.text = String(value)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsTextFieldTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let model = model as? SettingsTextFieldTableViewCellModel else { return }
        guard let text = textField.text, !text.isEmpty, let value = Int(text) else {
            textField.text = String(model.value)
            model.valueChanged?(model.value)
            return
        }
        model.valueChanged?(value)
    }
}
