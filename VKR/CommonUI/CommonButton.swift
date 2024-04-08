//
//  CommonButton.swift
//  VKR
//
//  Created by Константин Хамицевич on 09.04.2024.
//

import UIKit

public final class CommonButton: UIButton {

    private lazy var customTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor =  UIColor.white
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textAlignment = .center
        view.numberOfLines = 1
        view.isUserInteractionEnabled = false
        view.adjustsFontSizeToFitWidth = true
        return view
    }()

    var title: String = "" {
        didSet {
            customTitleLabel.text = title
        }
    }

    override public var isEnabled: Bool {
        didSet {
            setupAppereance()
        }
    }

    init() {
        super.init(frame: .zero)

        setupView()
        setupLayer()
        setupAppereance()
        setupTargets()
    }

    private func setupView() {
        addSubview(customTitleLabel)
        customTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
            make.height.equalTo(24)
        }
    }

    private func setupLayer() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }

    private func setupAppereance() {
        backgroundColor = isEnabled ? backgroundColor : UIColor.gray.withAlphaComponent(0.5)
        customTitleLabel.textColor = isEnabled ? UIColor.white : UIColor.gray
    }

    private func setupTargets() {
        addTarget(self, action: #selector(buttonTappedInside), for: .touchDown)
        let events: [UIControl.Event] = [.touchUpInside, .touchCancel, .touchDragExit]
        events.forEach { event in
            addTarget(self, action: #selector(buttonTappedOutside), for: event)
        }
    }

    @objc private func buttonTappedInside() { alpha = 0.7 }

    @objc private func buttonTappedOutside() { alpha = 1 }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
