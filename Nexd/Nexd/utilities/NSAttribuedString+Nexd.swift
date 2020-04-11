//
//  NSAttribuedString+NExd.swift
//  nexd
//
//  Created by Tobias Schröpf on 10.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

func + (left: String, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(NSAttributedString(string: left, attributes: nil))
    result.append(right)
    return result
}

func + (left: NSAttributedString, right: String) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(NSAttributedString(string: right, attributes: nil))
    return result
}
