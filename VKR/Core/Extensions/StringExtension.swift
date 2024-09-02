//
//  StringExtension.swift
//  VKR
//
//  Created by Константин Хамицевич on 13.04.2024.
//

import Foundation

extension String {
    func translate() -> String { LocalizationService.shared.getTranslationBy(self) }
}
