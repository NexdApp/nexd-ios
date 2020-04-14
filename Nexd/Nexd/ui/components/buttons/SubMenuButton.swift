//
//  SubMenuButton.swift
//  nexd
//
//  Created by Tobias Schröpf on 11.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class SubMenuButton: CustomControl {
    private let image = UIImageView()
    private let label = UILabel()

    override func setupView() {
        backgroundColor = .clear
        addSubview(image)
        addSubview(label)
    }

    override func setupConstraints() {
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }

        label.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(image.snp.left).offset(-25)
        }
    }

    static func make(title: String?) -> SubMenuButton {
        let button = SubMenuButton()

        button.label.numberOfLines = 1
        button.label.attributedText = title?.asPositiveButtonText()
        button.image.image = R.image.chevron()?.withTintColor(R.color.positiveButtonText()!)

        return button
    }
}
