//
//  SectionHeaderView.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    lazy var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)

        label.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static var reuseIdentifier: String {
        return "\(self)"
    }
}
