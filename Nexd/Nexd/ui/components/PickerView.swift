//
//  PickerView.swift
//  nexd
//
//  Created by Tobias Schröpf on 11.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

protocol PickerViewDelegate: class {
    func didTapDone()
    func didTapCancel()
}

class PickerView: UIPickerView {
    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: PickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: R.string.localizable.ok_button_title(), style: .plain, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: R.string.localizable.cancel_button_title(), style: .plain, target: self, action: #selector(cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        toolbar = toolBar
    }

    @objc func doneTapped() {
        toolbarDelegate?.didTapDone()
    }

    @objc func cancelTapped() {
        toolbarDelegate?.didTapCancel()
    }
}
