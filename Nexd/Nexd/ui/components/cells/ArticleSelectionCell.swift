//
//  ArticleSelectionCell.swift
//  nexd
//
//  Created by Tobias Schröpf on 10.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class ArticleSelectionCell: UICollectionViewCell {
    struct Item {
        let title: String
        let amount: String

        let amountChanged: ((Int) -> Void)?
    }

    lazy var title = UILabel()
    lazy var amount = UITextField()

    fileprivate var amountChanged: ((Int) -> Void)?
    fileprivate let pickerView = PickerView()

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

        amount.inputView = pickerView
        amount.inputAccessoryView = pickerView.toolbar

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.toolbarDelegate = self

        pickerView.reloadAllComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(to item: Item) {
        title.attributedText = item.title.asListItemTitle()
        amount.attributedText = item.amount.asAmountText()
        amountChanged = item.amountChanged

        if let value = Int(item.amount) {
            pickerView.selectRow(value, inComponent: 0, animated: false)
        }
    }

    static var reuseIdentifier: String {
        return "\(self)"
    }
}

extension ArticleSelectionCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        100
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(row)"
    }
}

extension ArticleSelectionCell: PickerViewDelegate {
    func didTapDone() {
        let row = pickerView.selectedRow(inComponent: 0)
        pickerView.selectRow(row, inComponent: 0, animated: false)
        amount.resignFirstResponder()
        amountChanged?(row)
    }

    func didTapCancel() {
        amount.text = nil
        amount.resignFirstResponder()
    }
}

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
