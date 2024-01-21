//
//  UIViewExtension.swift
//  VKR
//
//  Created by Константин Хамицевич on 20.01.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}
