//
//  HelperRequestFilterSettings.swift
//  nexd
//
//  Created by Tobias Schröpf on 27.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import SwiftUI

struct HelperRequestFilterSettingsView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            NexdUI.Texts.title(text: R.string.localizable.helper_request_filter_settings_screen_title.text)
                .padding([.leading, .trailing], 25)
                .padding(.top, 70)

            NexdUI.Texts.h2Dark(text: R.string.localizable.helper_request_filter_settings_heading_zipcode.text)
                .padding(.top, 48)
                .padding([.leading, .trailing], 12)

            NexdUI.ValidatingTextField(tag: 0,
                                       text: $viewModel.zipCode,
                                       placeholder: R.string.localizable.helper_request_filter_settings_placeholder_zipcode(),
                                       validationRules: .zipCode,
                                       inputConfiguration: NexdUI.InputConfiguration(keyboardType: .numberPad,
                                                                                     autocapitalizationType: .none,
                                                                                     autocorrectionType: .no,
                                                                                     spellCheckingType: .no,
                                                                                     hasDone: true))
                .padding(.bottom, 24)
                .padding([.leading, .trailing], 12)

            Spacer()
        }
        .keyboardAdaptive()
        .dismissingKeyboard()
        .withModalButtons(onCancel: { self.viewModel.onCancelPressed() },
                          onDone: { self.viewModel.onDonePressed() })
    }
}

extension HelperRequestFilterSettingsView {
    struct Result {
        let zipCode: String?
    }

    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating

        @Published fileprivate var zipCode: String?

        private let onCancelled: () -> Void
        private let onFinished: (Result) -> Void

        init(navigator: ScreenNavigating,
             zipCode: String?,
             onCancelled: @escaping (() -> Void),
             onFinished: @escaping ((Result) -> Void)) {
            self.navigator = navigator
            self.zipCode = zipCode
            self.onCancelled = onCancelled
            self.onFinished = onFinished
        }

        func onDonePressed() {
            onFinished(Result(zipCode: zipCode))
        }

        func onCancelPressed() {
            onCancelled()
        }
    }

    static func createScreen(viewModel: HelperRequestFilterSettingsView.ViewModel) -> ModalScreen<HelperRequestFilterSettingsView> {
        let screen = ModalScreen(rootView: HelperRequestFilterSettingsView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}
