//
//  BackButton.swift
//  nexd
//
//  Created by Tobias Schröpf on 10.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class ConfirmButton: CustomControl {
    private let image = UIImageView()
    private let label = UILabel()

    override func setupView() {
        backgroundColor = .clear
        label.numberOfLines = 1

        image.image = R.image.chevron()?.withTintColor(R.color.positiveButtonText()!)
        label.attributedText = R.string.localizable.confirm_button_title().asPositiveButtonText()

        addSubview(image)
        addSubview(label)
    }

    override func setupConstraints() {
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(image.snp.left).offset(-25)
        }
    }
}
