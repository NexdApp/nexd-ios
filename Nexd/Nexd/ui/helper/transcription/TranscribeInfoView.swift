//
//  TranscribeInfoView.swift
//  nexd
//
//  Created by Tobias Schröpf on 14.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import NexdClient
import RxCombine
import RxSwift
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
                    self.viewModel.onConfirmButtonTapped()
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
        .dismissingKeyboard()
        .onAppear { self.viewModel.bind() }
        .onDisappear { self.viewModel.unbind() }
    }
}

extension TranscribeInfoView {
    enum TranscribeError: Error {
        case recordingDownloadFailed
    }

    class ViewModel: ObservableObject {
        class ViewState: ObservableObject {
            fileprivate var player: AudioPlayer?

            @Published var call: Call?
            @Published var isPlaying: Bool = false
            @Published var progress: Double = 0
            @Published var firstName: String = ""
        }

        private let navigator: ScreenNavigating
        private let phoneService: PhoneService

        private var cancellableSet: Set<AnyCancellable>?
        var state = ViewState()

        func onPlayPause() {
            state.isPlaying ? state.player?.pause() : state.player?.play()
        }

        func onSliderMoved(to progress: Double) {
            state.player?.seekTo(progress: Float(progress))
        }

        func onConfirmButtonTapped() {
            navigator.toTranscribeListView()
        }

        init(navigator: ScreenNavigating, phoneService: PhoneService) {
            self.navigator = navigator
            self.phoneService = phoneService
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

            let call = phoneService.oneCall()
                .asObservable()
                .share(replay: 1, scope: .whileConnected)

            call
                .publisher
                .replaceError(with: nil)
                .assign(to: \.call, on: state)
                .store(in: &cancellableSet)

            let player = call
                .flatMap { [weak self] call -> Single<URL> in
                    guard let self = self, let call = call else { return Single.error(TranscribeError.recordingDownloadFailed) }
                    return self.phoneService.downloadRecoring(for: call)
                }
                .map { url in AudioPlayer(url: url) }

            player
                .publisher
                .map { player -> AudioPlayer? in player }
                .replaceError(with: nil)
                .assign(to: \.player, on: state)
                .store(in: &cancellableSet)

            let playerState = player
                .flatMap { $0.state }

            playerState
            .debug("ZEFIX - playerState")
                .publisher
                .map { $0.isPlaying }
                .removeDuplicates()
                .receive(on: RunLoop.main)
                .replaceError(with: false)
                .assign(to: \.isPlaying, on: state)
                .store(in: &cancellableSet)

            playerState.publisher
                .map { Double($0.progress) }
                .removeDuplicates()
                .receive(on: RunLoop.main)
                .replaceError(with: 0)
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
            let viewModel = TranscribeInfoView.ViewModel(navigator: PreviewNavigator(), phoneService: PhoneService())
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
