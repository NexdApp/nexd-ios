//
//  UIButton+Shadow.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension UIButton {

    func style() {
        backgroundColor = .gray
        layer.cornerRadius = 10
        clipsToBounds = true
    }

    func addShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3;
        layer.shadowRadius = 2;
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0);
    }
}
