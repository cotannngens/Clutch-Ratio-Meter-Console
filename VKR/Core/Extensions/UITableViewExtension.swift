//
//  UITableViewExtension.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit

extension UITableView {    
    func registerWithType<T: UITableViewCell>(cell: T.Type) {
        self.register(cell, forCellReuseIdentifier: cell.reuseIdentifier)
    }
}

extension UITableViewCell {
    class var reuseIdentifier: String { return String.init(describing: self)}
}

// MARK: UITableView+Structure

extension UITableView {
    
    func numberOfSections(in structure: TableViewStructure) -> NSInteger {
        return structure.sections.count
    }
    
    func numberOfRows(in structure: TableViewStructure, section: NSInteger) -> NSInteger {
        guard section >= 0 && section < structure.sections.count else { return 0 }
        return structure.sections[section].cellModels.count
    }
    
    func dequeueReusableCell(with structure: TableViewStructure, indexPath: IndexPath) -> BaseTableViewCell {
        let model = structure.cellModel(for: indexPath)
        var baseTableViewCell: BaseTableViewCell = BaseTableViewCell()
        if let cell = dequeueReusableCell(withIdentifier: model.cellIdentifier) as? BaseTableViewCell {
            baseTableViewCell = cell
        }
        baseTableViewCell.setup(with: model)
        return baseTableViewCell
    }
    
    func heightForRow(atIndexPath indexPath: IndexPath, in structure: TableViewStructure) -> CGFloat {
        return structure.cellModel(for: indexPath).height
    }
}

