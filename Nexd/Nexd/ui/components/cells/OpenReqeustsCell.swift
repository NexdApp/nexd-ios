//
//  OpenReqeustsCell.swift
//  nexd
//
//  Created by Tobias Schröpf on 12.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class OpenReqeustsCell: UICollectionViewCell {
    struct Item {
        let title: String
        let details: String?
    }

    private let container = UIView()
    let title = UILabel()
    private let accessoryView = UILabel()

    fileprivate var amountChanged: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(container)
        container.layer.masksToBounds = true
        container.layer.borderWidth = 1
        container.layer.borderColor = R.color.darkListItemBorder()?.cgColor
        container.layer.cornerRadius = 10
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(53)
        }

        container.addSubview(title)

        title.backgroundColor = .clear

        title.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
        }

        container.addSubview(accessoryView)
        accessoryView.snp.makeConstraints { make -> Void in
            make.left.equalTo(title.snp.right).offset(14)
            make.top.equalToSuperview().inset(3)
            make.right.equalToSuperview().inset(13)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(to item: Item) {
        title.attributedText = item.title.asDarkListItemTitle()
        accessoryView.attributedText = item.details?.asDarkListItemDetails()
    }
}
