//
//  CheckableCell.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class CheckableCell: UICollectionViewCell {
    struct Item: Hashable {
        let isChecked: Bool
        let text: String
    }

    lazy var checkmark = UIImageView()
    lazy var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(label)
        contentView.addSubview(checkmark)

        label.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.right.equalTo(checkmark.snp.left).offset(8)
            make.centerY.equalToSuperview()
        }

        checkmark.tintColor = .black
        checkmark.snp.makeConstraints { make -> Void in
            make.width.height.equalTo(40)
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(to item: Item) {
        checkmark.image = item.isChecked ? R.image.baseline_check_black_48pt() : nil
        label.text = item.text
    }

    static var reuseIdentifier: String {
        return "\(self)"
    }
}
