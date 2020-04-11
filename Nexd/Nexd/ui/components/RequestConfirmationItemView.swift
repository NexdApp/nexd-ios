//
//  RequestConfirmationItem.swift
//  nexd
//
//  Created by Tobias Schröpf on 11.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class RequestConfirmationItemView: View {
    let title = UILabel()
    let amount = UILabel()

    override func setupView() {
        addSubview(title)
        addSubview(amount)
        amount.textAlignment = .right
    }

    override func setupConstraints() {
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(27)
            make.right.equalTo(amount.snp.left).offset(-8)
            make.top.bottom.equalToSuperview()
        }

        amount.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-23)
            make.top.bottom.equalToSuperview()
        }
    }
}
