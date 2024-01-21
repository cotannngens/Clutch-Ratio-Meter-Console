//
//  BaseTableViewCell.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {
    
    open weak var model: BaseTableViewCellModel?
    
    // buttons or other views, that should not pass through touch event to cell
    open var viewsThatCancelsTouches: [UIView]?
    
    open var cellIdentifier: String {
        return String(describing: self)
    }
    
    open var cellType: Any {
        return type(of: self)
    }
    
    open func setup(with model: BaseTableViewCellModel) {
        self.model = model
        updateAppearance()
    }
    
    open func updateAppearance() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(cellTap))
        gr.cancelsTouchesInView = false
        addGestureRecognizer(gr)
        isUserInteractionEnabled = model?.userInteractionEnabled ?? true
        selectionStyle = .none
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        let gr = UITapGestureRecognizer(target: self, action: #selector(cellTap))
        gr.cancelsTouchesInView = false
        addGestureRecognizer(gr)
    }
    
    @objc private func cellTap() {
        model?.tapAction?()
        isUserInteractionEnabled = model?.userInteractionEnabled ?? true
    }
}

