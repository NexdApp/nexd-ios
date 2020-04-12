//
//  ArticleSelectionCell.swift
//  nexd
//
//  Created by Tobias Schröpf on 10.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class AcceptedRequestCell: UICollectionViewCell {
    struct Item {
        let title: String
    }

    private let container = UIView()
    let title = UILabel()
    private let accessoryView = UIImageView()

    fileprivate var amountChanged: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(container)
        container.layer.masksToBounds = true
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.white.cgColor
        container.layer.cornerRadius = 10
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(39)
        }

        container.addSubview(title)

        title.backgroundColor = .clear

        title.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        container.addSubview(accessoryView)

        accessoryView.backgroundColor = .clear
        accessoryView.layer.masksToBounds = true
        accessoryView.layer.cornerRadius = 18.5

        accessoryView.snp.makeConstraints { make -> Void in
            make.left.equalTo(title.snp.right).offset(14)
            make.right.equalToSuperview().offset(-8)
            make.size.equalTo(CGSize(width: 37, height: 37))
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(to item: Item) {
        title.attributedText = item.title.asDarkButtonText()
    }
}
