//
//  IndicatorTableCell.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit
import SnapKit

final class IndicatorTableСell: BaseTableViewCell {

    private var inidicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.tintColor = UIColor.commonBlack
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        separatorInset = .init(top: 0, left: 1000, bottom: 0, right: 0)
        contentView.addSubview(inidicator)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateAppearance() {
        super.updateAppearance()
        setup()
    }

    func setup() {
        inidicator.snp.remakeConstraints { make in
            make.height.width.equalTo(24.0)
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(18.0)
        }

        DispatchQueue.main.async {
            self.inidicator.startAnimating()
        }
    }
}
