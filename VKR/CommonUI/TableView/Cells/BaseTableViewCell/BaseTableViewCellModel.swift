//
//  BaseTableViewCellModel.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit

open class BaseTableViewCellModel: NSObject {
    
    open var cellIdentifier: String {
        return ""
    }
    
    open var height: CGFloat {
        return UITableView.automaticDimension
    }
    
    open var didSelect: (() -> Void)?
    open var tapAction: (() -> Void)?
    open var reloadView: (() -> Void)?
    open var userInteractionEnabled = true
    
    public init(tapAction: (() -> Void)? = nil, reloadView: (() -> Void)? = nil) {
        self.tapAction = tapAction
        self.reloadView = reloadView
    }
}

