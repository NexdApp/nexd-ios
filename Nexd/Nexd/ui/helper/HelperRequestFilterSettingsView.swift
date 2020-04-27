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
            NexdUI.Headings.title(text: R.string.localizable.helper_request_filter_settings_screen_title.text)
                .padding([.leading, .trailing], 25)
                .padding(.top, 70)

            NexdUI.Headings.h2Dark(text: R.string.localizable.helper_request_filter_settings_heading_zipcode.text)
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

            NexdUI.Buttons.confirm {
                self.viewModel.confirmButtonTapped()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 25)
            .padding(.bottom, 24)
        }
        .keyboardAdaptive()
        .dismissingKeyboard()
    }
}

extension HelperRequestFilterSettingsView {
    struct Result {
        let zipCode: String
    }

    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating

        @Published fileprivate var zipCode: String?
        private let onFinished: (Result) -> Void

        init(navigator: ScreenNavigating,
             zipCode: String?,
             onFinished: @escaping ((Result) -> Void)) {
            self.navigator = navigator
            self.zipCode = zipCode
            self.onFinished = onFinished
        }

        func confirmButtonTapped() {
            log.debug("Confirm")
        }
    }

    static func createScreen(viewModel: HelperRequestFilterSettingsView.ViewModel) -> ModalScreen<HelperRequestFilterSettingsView> {
        let screen = ModalScreen(rootView: HelperRequestFilterSettingsView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}
