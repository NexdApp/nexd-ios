//
//  String+Nexd.swift
//  Nexd
//
//  Created by Tobias Schröpf on 01.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension String {
    func asAttributedDefault() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }

    func asAttributedHeader() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }

    func asAttributedPlaceholder() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textFieldPlaceholderTextColor
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }

    func asAttributedErrorLabel() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.errorTintColor,
            .font: UIFont.systemFont(ofSize: 12)
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }

    func asAttributedWarningLabel() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.warningTintColor,
            .font: UIFont.systemFont(ofSize: 12)
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }
}
