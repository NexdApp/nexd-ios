//
//  HelperOptionsViewController.swift
//  nexd
//
//  Created by Tobias Schröpf on 11.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

struct HelperOptionsView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            NexdUI.Texts.title(text: R.string.localizable.helper_type_screen_title.text)
                .padding(.top, 70)
                .padding([.leading, .trailing], 20)

            NexdUI.Buttons.darkMainMenuButton(text: R.string.localizable.helper_type_button_transcript.text) {
                self.viewModel.transcribeCallTapped()
            }
            .padding([.leading, .trailing], 12)

            NexdUI.Buttons.darkMainMenuButton(text: R.string.localizable.helper_type_button_shopping.text) {
                self.viewModel.goShoppingTapped()
            }
            .padding([.leading, .trailing], 12)

            Spacer()
        }
        .withBackButton { self.viewModel.backButtonTapped() }
    }
}

extension HelperOptionsView {
    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
        }

        func backButtonTapped() {
            navigator.goBack()
        }

        func transcribeCallTapped() {
            navigator.toTranscribeInfoView()
        }

        func goShoppingTapped() {
            navigator.toHelperOverview()
        }
    }

    static func createScreen(viewModel: HelperOptionsView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: HelperOptionsView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}

#if DEBUG
    struct HelperOptionsView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = HelperOptionsView.ViewModel(navigator: PreviewNavigator())
            return Group {
                HelperOptionsView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.locale, .init(identifier: "de"))

                HelperOptionsView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                HelperOptionsView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
