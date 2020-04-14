//
//  Control.swift
//  nexd
//
//  Created by Tobias Schröpf on 12.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class CustomControl: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }

        setupConstraints()
    }

    func setupView() {
        // override in subclasses
    }

    func setupConstraints() {
        // override in subclasses
    }
}
