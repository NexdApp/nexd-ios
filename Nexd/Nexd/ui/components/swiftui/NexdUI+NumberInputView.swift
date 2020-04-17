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
        fileprivate var uiView: UITextField {
            let wrappedView = UITextField()

            wrappedView.backgroundColor = R.color.defaultBackground()
            wrappedView.textAlignment = .center
            wrappedView.inputView = pickerView
            wrappedView.inputAccessoryView = pickerView.toolbar

            wrappedView.attributedText = text?.asAmountText()

            pickerView.toolbarDelegate = self
            pickerView.reloadAllComponents()

            return wrappedView
        }

        let text: String?
        var onValueConfirmed: ((Int) -> Void)?
        var onCancel: (() -> Void)?

        init(text: String? = nil, onValueConfirmed: ((Int) -> Void)? = nil, onCancel: (() -> Void)? = nil) {
            self.text = text
            self.onValueConfirmed = onValueConfirmed
            self.onCancel = onCancel
        }

        fileprivate let pickerView = IntegerPickerView()

        func makeUIView(context: UIViewRepresentableContext<NumberInputView>) -> UITextField {
            return uiView
        }

        func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<NumberInputView>) {
            uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
            uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)

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
