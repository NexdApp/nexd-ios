//
//  DefaultCell.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class DefaultCell: UICollectionViewCell {
    lazy var icon = UIView()
    lazy var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(icon)
        contentView.addSubview(label)

        icon.snp.makeConstraints { make -> Void in
            make.width.height.equalTo(20)
            make.leftMargin.equalTo(8)
            make.centerY.equalToSuperview()
        }

        label.snp.makeConstraints { make -> Void in
            make.rightMargin.equalTo(8)
            make.left.equalTo(icon.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(to item: DefaultCellItem) {
        icon.backgroundColor = item.iconColor
        label.text = item.text
    }

    static var reuseIdentifier: String {
        return "\(self)"
    }
}
