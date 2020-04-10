//
//  ArticleSelectionCell.swift
//  nexd
//
//  Created by Tobias Schröpf on 10.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class ArticleSelectionCell: UICollectionViewCell {
    struct Item: Hashable {
        let title: String
        let amount: String
    }

    lazy var title = UILabel()
    lazy var amount = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(title)
        contentView.addSubview(amount)

        title.backgroundColor = R.color.defaultBackground()
        title.layer.masksToBounds = true
        title.layer.cornerRadius = 10

        amount.backgroundColor = R.color.defaultBackground()
        amount.textAlignment = .center
        amount.layer.masksToBounds = true
        amount.layer.cornerRadius = 18.5

        title.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.height.equalTo(48)
            make.centerY.equalToSuperview()
        }

        amount.snp.makeConstraints { make -> Void in
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
        title.attributedText = item.title.asListItemTitle()
        amount.attributedText = item.amount.asAmountText()
    }

    static var reuseIdentifier: String {
        return "\(self)"
    }
}
