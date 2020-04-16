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

                NexdUI.Player(isPlaying: $viewModel.state.isPlaying,
                              progress: $viewModel.state.progress,
                              onPlayPause: { self.viewModel.onPlayPause() },
                              onProgressEdited: { progress in self.viewModel.onSliderMoved(to: progress) })

                NexdUI.TextField(tag: 0,
                                 placeholder: R.string.localizable.transcribe_info_input_text_title_first_name(),
                                 onCommit: { string in log.debug("should commit: \(string ?? "-")") })
                    .padding(.top, 44)

                NexdUI.TextField(tag: 1,
                                 placeholder: R.string.localizable.transcribe_info_input_text_title_last_name(),
                                 onCommit: { string in log.debug("should commit: \(string ?? "-")") })
                    .padding(.top, 30)

                NexdUI.TextField(tag: 2,
                                 placeholder: R.string.localizable.transcribe_info_input_text_title_postal_code(),
                                 onCommit: { string in log.debug("should commit: \(string ?? "-")") })
                    .padding(.top, 30)

                NexdUI.Buttons.default(text: R.string.localizable.transcribe_info_button_title_confirm.text) {
                    self.viewModel.navigator.toTranscribeListView()
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
        class ViewState: ObservableObject {
            @Published var isPlaying: Bool = false
            @Published var progress: Double = 0
            @Published var firstName: String = ""
        }

        let navigator: ScreenNavigating
        private let player: AudioPlayer

        private var cancellableSet: Set<AnyCancellable>?
        var state = ViewState()

        func onPlayPause() {
            state.isPlaying ? player.pause() : player.play()
        }

        func onSliderMoved(to progress: Double) {
            player.seekTo(progress: Float(progress))
        }

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
            player = AudioPlayer.sampleMp3()
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

            player.state.publisher
                .map { $0.isPlaying }
                .removeDuplicates()
                .receive(on: RunLoop.main)
                .replaceError(with: false)
                .assign(to: \.isPlaying, on: state)
                .store(in: &cancellableSet)

            player.state.publisher
                .map { Double($0.progress) }
                .removeDuplicates()
                .receive(on: RunLoop.main)
                .replaceError(with: 0)
                .debug()
                .assign(to: \.progress, on: state)
                .store(in: &cancellableSet)

            state.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
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
