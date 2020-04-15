//
//  TranscribeInfoView.swift
//  nexd
//
//  Created by Tobias Schröpf on 14.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import RxCombine
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
                        self.viewModel.onPlayPause()
                    },
                           label: {
                        viewModel.isPlaying ? R.image.pause.image : R.image.play.image
                    })
                        .frame(width: 35, height: 35)
                        .foregroundColor(R.color.playerButton.color)

                    Slider(value: $viewModel.progress, in: 0.0 ... 1.0,
                           onEditingChanged: { isEditing in
                            guard !isEditing else { return }
                            self.viewModel.onSliderMoved()
                    })
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
        .onAppear { self.viewModel.bind() }
        .onDisappear { self.viewModel.unbind() }
    }
}

extension TranscribeInfoView {
    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating
        private let player: AudioPlayer

        private var cancellableSet: Set<AnyCancellable>?

        @Published var isPlaying: Bool = false
        @Published var progress: Float = 0
        @Published var firstName: String = ""

        func onPlayPause() {
            isPlaying ? player.pause() : player.play()
        }

        func onSliderMoved() {
            player.seekTo(progress: progress)
        }

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
            player = AudioPlayer.sampleMp3()
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

            player.state.publisher
                .map { $0.isPlaying }
                .receive(on: RunLoop.main)
                .replaceError(with: false)
                .assign(to: \.isPlaying, on: self)
                .store(in: &cancellableSet)

            player.state.publisher
                .map { $0.progress }
                .receive(on: RunLoop.main)
                .replaceError(with: 0)
                .assign(to: \.progress, on: self)
                .store(in: &cancellableSet)

            self.cancellableSet = cancellableSet
        }

        func unbind() {
            cancellableSet = nil
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
