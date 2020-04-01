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
}
