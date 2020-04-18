//
//  TranscribeEndView.swift
//  nexd
//
//  Created by Tobias Schröpf on 18.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

struct TranscribeEndView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        return VStack {
            NexdUI.Headings.title(text: R.string.localizable.transcribe_end_screen_title_ios.text)
                .padding(.top, 225)
                .padding([.leading, .trailing], 45)

            Spacer()

            NexdUI.Buttons.default(text: R.string.localizable.transcribe_end_button_title_complete.text) {
                self.viewModel.onDonePressed()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 112)
            .padding([.leading, .trailing], 45)
        }
    }
}

extension TranscribeEndView {
    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
        }

        func onDonePressed() {
            navigator.toMainScreen()
        }
    }

    static func createScreen(viewModel: TranscribeEndView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: TranscribeEndView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}
