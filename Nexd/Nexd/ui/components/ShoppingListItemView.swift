//
//  ShoppingListItemView.swift
//  nexd
//
//  Created by Tobias Schröpf on 12.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class ShoppingListItemView: CustomView {
    let title = UILabel()
    let amount = UILabel()
    private var doneState: Bool = true
    let strikeThrough = UIView()
    override func setupView() {
        addSubview(title)
        addSubview(amount)
        addSubview(strikeThrough)
        strikeThrough.isHidden = doneState
        strikeThrough.backgroundColor = .black
        amount.textAlignment = .right
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
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
        strikeThrough.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-17)
            make.left.equalToSuperview().offset(17)
            make.height.equalTo(2)
            make.centerY.equalTo(self)
        }
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        doneState = !doneState
        strikeThrough.isHidden = doneState
    }
}
