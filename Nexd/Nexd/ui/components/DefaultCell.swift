//
//  DefaultCell.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class DefaultCell: UICollectionViewCell {
    struct Item: Hashable {
        let icon: UIImage?
        let text: String
    }

    lazy var icon = UIImageView()
    lazy var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(icon)
        contentView.addSubview(label)

        icon.styleDefault()
        label.styleDefault()

        icon.snp.makeConstraints { make -> Void in
            make.width.height.equalTo(20)
            make.rightMargin.equalTo(-8)
            make.centerY.equalToSuperview()
        }

        label.snp.makeConstraints { make -> Void in
            make.left.equalTo(8)
            make.right.equalTo(icon.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(to item: Item) {
        icon.image = item.icon
        label.text = item.text
    }

    static var reuseIdentifier: String {
        return "\(self)"
    }
}
