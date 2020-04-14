//
//  TranscribeInfoView.swift
//  nexd
//
//  Created by Tobias Schröpf on 14.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import SwiftUI

struct TranscribeInfoView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        return VStack {
            Group {
                NexdUI.Headings.title(text: R.string.localizable.transcribe_info_screen_title.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 71)

                HStack {
                    Button(action: {
                        log.debug("Play/pause toggle")
                    }) { R.image.play.image }
                        .foregroundColor(R.color.playerButton.color)

                    Slider(value: viewModel.$playerProgress, in: 0.0 ... 1.0)
                        .accentColor(.white)
                }

                NexdUI.TextField(tag: 0,
                                 placeholder: R.string.localizable.transcribe_info_input_text_title_first_name(),
                                 onChanged: { text in log.debug("Text changed: \(text)") },
                                 onCommit: { string in log.debug("should commit: \(string ?? "-")") })
                    .padding(.top, 44)

                NexdUI.TextField(tag: 1,
                                 placeholder: R.string.localizable.transcribe_info_input_text_title_last_name(),
                                 onChanged: { text in log.debug("Text changed: \(text)") },
                                 onCommit: { string in log.debug("should commit: \(string ?? "-")") })
                    .padding(.top, 30)

                NexdUI.TextField(tag: 2,
                                 placeholder: R.string.localizable.transcribe_info_input_text_title_postal_code(),
                                 onChanged: { text in log.debug("Text changed: \(text)") },
                                 onCommit: { string in log.debug("should commit: \(string ?? "-")") })
                    .padding(.top, 30)

                NexdUI.Buttons.default(text: R.string.localizable.transcribe_info_button_title_confirm.text) {
                    log.debug("IMPLEMENT ME!")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 64)
                .padding(.bottom, 53)
            }
            .padding(.leading, 26)
            .padding(.trailing, 33)
        }
        .padding(.bottom, 0)
        .keyboardAdaptive()
    }
}

extension TranscribeInfoView {
    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating

        @State var playerProgress: CGFloat = 0.5
        @State var firstName: String = ""

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
        }
    }

    static func createScreen(viewModel: TranscribeInfoView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: TranscribeInfoView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}

#if DEBUG
    struct TranscribeInfoView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = TranscribeInfoView.ViewModel(navigator: PreviewNavigator())
            return Group {
                TranscribeInfoView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.locale, .init(identifier: "de"))

                TranscribeInfoView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                TranscribeInfoView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
