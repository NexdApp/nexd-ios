//
//  IntegerPickerView.swift
//  nexd
//
//  Created by Tobias Schröpf on 11.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class IntegerPickerView: PickerView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        dataSource = self
        delegate = self
    }
}

extension IntegerPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        100
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        "\(row)".asAmountText()
    }
}
