//
//  FilterButton.swift
//  nexd
//
//  Created by Tobias Schröpf on 27.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class FilterButton: CustomControl {
    private let image = UIImageView()
    let titleLabel = UILabel()
    let detailsLabel = UILabel()

    override func setupView() {
        backgroundColor = .clear
        titleLabel.numberOfLines = 1

        image.image = R.image.chevron()?.withTintColor(R.color.positiveButtonText()!)

        addSubview(image)
        addSubview(titleLabel)
        addSubview(detailsLabel)
    }

    override func setupConstraints() {
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(10)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.right.equalTo(image.snp.left).offset(-25)
        }

        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.right.equalTo(image.snp.left).offset(-25)
        }
    }
}
