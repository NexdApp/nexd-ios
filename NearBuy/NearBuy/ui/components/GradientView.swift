//
//  GradientView.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class GradientView: UIView {
    open override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    init() {
        super.init(frame: .zero)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.gradientGreen.cgColor]
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.gradientGreen.cgColor]
    }
}
