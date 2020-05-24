//
//  NexdUI+NumberInput.swift
//  nexd
//
//  Created by Tobias Schröpf on 16.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI
import UIKit

extension NexdUI {
    final class NumberInputView: UIViewRepresentable {
        let text: String?
        let onValueConfirmed: ((Int) -> Void)?
        let onCancel: (() -> Void)?

        fileprivate let pickerView = IntegerPickerView()

        init(text: String? = nil, onValueConfirmed: ((Int) -> Void)? = nil, onCancel: (() -> Void)? = nil) {
            self.text = text
            self.onValueConfirmed = onValueConfirmed
            self.onCancel = onCancel
        }

        func makeUIView(context: UIViewRepresentableContext<NumberInputView>) -> UITextField {
            let uiView = UITextField()

            uiView.backgroundColor = R.color.defaultBackground()
            uiView.textAlignment = .center
            uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
            uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)

            return uiView
        }

        func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<NumberInputView>) {
            uiView.attributedText = text?.asAmountText()
            uiView.inputView = pickerView
            uiView.inputAccessoryView = pickerView.toolbar
            pickerView.toolbarDelegate = self
            pickerView.reloadAllComponents()
        }
    }
}

extension NexdUI.NumberInputView: PickerViewDelegate {
    func didTapDone() {
        let row = pickerView.selectedRow(inComponent: 0)
        pickerView.selectRow(row, inComponent: 0, animated: false)

        UIApplication.shared.endEditing()
        onValueConfirmed?(row)
    }

    func didTapCancel() {
        UIApplication.shared.endEditing()
    }
}

#if DEBUG
    struct NumberInputView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                NexdUI.NumberInputView()
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
