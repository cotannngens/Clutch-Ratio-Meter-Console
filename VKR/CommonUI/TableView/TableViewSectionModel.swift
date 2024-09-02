//
//  TableViewSectionModel.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit

public struct TableViewSectionModel {

    public var heightForHeader: CGFloat = 0
    public var heightForFooter: CGFloat = 0

    public var viewForHeader: UIView?
    public var viewForFooter: UIView?

    public var cellModels: [BaseTableViewCellModel]

    public init(cellModels: [BaseTableViewCellModel]) {
        self.cellModels = cellModels
    }
}
