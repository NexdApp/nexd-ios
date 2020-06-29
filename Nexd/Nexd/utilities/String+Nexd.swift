//
//  String+Nexd.swift
//  Nexd
//
//  Created by Tobias Schröpf on 01.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension String {
    func asPlaceholder() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.textfieldStroke()!
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }

    func asLink(range: Range<String.Index>?, target: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: R.font.proximaNovaRegular(size: 16)!
        ]

        let attributedString = NSMutableAttributedString(string: self, attributes: attributes)

        guard let range = range else { return attributedString }
        attributedString.addAttribute(.link, value: target, range: NSRange(range, in: self))
        return attributedString
    }

    var cstring: UnsafePointer<CChar> {
        (self as NSString).utf8String!
    }
}
