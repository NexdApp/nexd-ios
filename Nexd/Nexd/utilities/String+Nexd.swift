//
//  String+Nexd.swift
//  Nexd
//
//  Created by Tobias Schröpf on 01.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension String {
    func asDefaultText() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }

    func asHeader() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }

    func asTitle() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.titleTextColor,
            .font: UIFont.boldSystemFont(ofSize: 36)
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }

    func asPlaceholder() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textFieldPlaceholderTextColor
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }

    func asErrorLabel() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.errorTintColor,
            .font: UIFont.systemFont(ofSize: 12)
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }

    func asWarningLabel() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.warningTintColor,
            .font: UIFont.systemFont(ofSize: 12)
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }

    func asLink(range: Range<String.Index>?, target: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16)
        ]

        let attributedString = NSMutableAttributedString(string: self, attributes: attributes)

        guard let range = range else { return attributedString }
        attributedString.addAttribute(.link, value: target, range: NSRange(range, in: self))
        return attributedString
    }

    func parseHtml() -> NSAttributedString? {
        return try? NSAttributedString(
            data: data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
    }
}

// concatenate attributed strings
func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}
