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
                NexdUI.Player(isPlaying: $viewModel.state.isPlaying,
                              progress: $viewModel.state.progress,
                              onPlayPause: { self.viewModel.onPlayPause() },
                              onProgressEdited: { progress in self.viewModel.onSliderMoved(to: progress) })
                    .padding(.top, 70)

                NexdUI.Texts.title(text: R.string.localizable.transcribe_info_screen_title.text)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView {
                    NexdUI.TextField(tag: 1,
                                     text: $viewModel.helpRequestCreationState.firstName,
                                     placeholder: R.string.localizable.transcribe_info_input_text_title_first_name(),
                                     inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                   autocorrectionType: .no,
                                                                                   spellCheckingType: .no,
                                                                                   hasNext: true))
                        .padding(.top, 12)

                    NexdUI.TextField(tag: 2,
                                     text: $viewModel.helpRequestCreationState.lastName,
                                     placeholder: R.string.localizable.transcribe_info_input_text_title_last_name(),
                                     inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                   autocorrectionType: .no,
                                                                                   spellCheckingType: .no,
                                                                                   hasPrevious: true,
                                                                                   hasNext: true))
                        .padding(.top, 12)

                    NexdUI.ValidatingTextField(tag: 3,
                                               text: $viewModel.helpRequestCreationState.zipCode,
                                               placeholder: R.string.localizable.transcribe_info_input_text_title_postal_code(),
                                               validationRules: .zipCode,
                                               inputConfiguration: NexdUI.InputConfiguration(keyboardType: .numberPad,
                                                                                             autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasNext: true))
                        .padding(.top, 12)

                    NexdUI.TextField(tag: 4,
                                     text: $viewModel.helpRequestCreationState.city,
                                     placeholder: R.string.localizable.transcribe_info_input_text_title_city(),
                                     inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                   autocorrectionType: .no,
                                                                                   spellCheckingType: .no,
                                                                                   hasPrevious: true,
                                                                                   hasNext: true))
                        .padding(.top, 12)

                    NexdUI.TextField(tag: 5,
                                     text: $viewModel.helpRequestCreationState.street,
                                     placeholder: R.string.localizable.transcribe_info_input_text_title_street(),
                                     inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                   autocorrectionType: .no,
                                                                                   spellCheckingType: .no,
                                                                                   hasPrevious: true,
                                                                                   hasNext: true))
                        .padding(.top, 12)

                    NexdUI.TextField(tag: 6,
                                     text: $viewModel.helpRequestCreationState.houseNumber,
                                     placeholder: R.string.localizable.transcribe_info_input_text_title_street_number(),
                                     inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                   autocorrectionType: .no,
                                                                                   spellCheckingType: .no,
                                                                                   hasPrevious: true,
                                                                                   hasNext: true))
                        .padding(.top, 12)

                    NexdUI.ValidatingTextField(tag: 7,
                                               text: $viewModel.helpRequestCreationState.phoneNumber,
                                               placeholder: R.string.localizable.transcribe_info_input_text_title_phone_number(),
                                               validationRules: .phone,
                                               inputConfiguration: NexdUI.InputConfiguration(keyboardType: .phonePad,
                                                                                             autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasDone: true))
                        .padding(.top, 12)
                }

                NexdUI.Buttons.default(text: R.string.localizable.transcribe_info_button_title_confirm.text) {
                    self.viewModel.onConfirmButtonTapped()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 0)
                .padding(.bottom, 40)
            }
            .padding(.leading, 26)
            .padding(.trailing, 33)
        }
        .padding(.bottom, 0)
        .keyboardAdaptive()
        .dismissingKeyboard()
        .onAppear { self.viewModel.bind() }
        .onDisappear { self.viewModel.unbind() }
        .withBackButton { self.viewModel.onBackButtonPressed() }
    }
}

extension TranscribeInfoView {
    enum TranscribeError: Error {
        case noCallsAvailable
    }

    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating
        private let phoneService: PhoneService
        private var cancellableSet: Set<AnyCancellable>?

        fileprivate var state: TranscribeViewState
        fileprivate var helpRequestCreationState: HelpRequestCreationState

        init(navigator: ScreenNavigating, phoneService: PhoneService, state: TranscribeViewState = TranscribeViewState()) {
            self.navigator = navigator
            self.phoneService = phoneService
            self.state = state
            self.helpRequestCreationState = state.helpRequestCreationState
        }

        func onBackButtonPressed() {
            navigator.goBack()
        }

        func onPlayPause() {
            state.isPlaying ? state.player?.pause() : state.player?.play()
        }

        func onSliderMoved(to progress: Double) {
            state.player?.seekTo(progress: Float(progress))
        }

        func onConfirmButtonTapped() {
            navigator.toTranscribeListView(state: state)
        }

        func bind() {
            let navigator = self.navigator
            var cancellableSet = Set<AnyCancellable>()

            let call = phoneService.oneCall()
                .asObservable()
                .share(replay: 1, scope: .whileConnected)

            call
                .map { [weak self] call -> Call in
                    guard let call = call else {
                        throw TranscribeError.noCallsAvailable
                    }

                    self?.helpRequestCreationState.phoneNumber = call.phoneNumber

                    return call
                }
                .catchError { error in
                    log.warning("Cannot download call information: \(error)")
                    return Completable.from {
                        navigator.showError(title: R.string.localizable.transcribe_info_error_title_no_calls(),
                                            message: R.string.localizable.transcribe_info_error_message_no_calls(),
                                            handler: { navigator.goBack() })
                    }
                    .asObservable()
                    .ofType()
                }
                .publisher
                .replaceError(with: nil)
                .assign(to: \.call, on: state)
                .store(in: &cancellableSet)

            let player = call
                .compactMap { $0?.recordingUrl }
                .compactMap { URL(string: $0) }
                .map { url in AudioPlayer(url: url) }
                .share(replay: 1, scope: .whileConnected)

            player
                .publisher
                .map { player -> AudioPlayer? in player }
                .replaceError(with: nil)
                .assign(to: \.player, on: state)
                .store(in: &cancellableSet)

            let playerState = player
                .flatMap { $0.state }

            playerState
                .publisher
                .map { $0.isPlaying }
                .removeDuplicates()
                .receive(on: RunLoop.main)
                .replaceError(with: false)
                .assign(to: \.isPlaying, on: state)
                .store(in: &cancellableSet)

            playerState
                .publisher
                .map { $0.progress ?? 0 }
                .removeDuplicates()
                .receive(on: RunLoop.main)
                .replaceError(with: 0)
                .assign(to: \.progress, on: state)
                .store(in: &cancellableSet)

            state.objectWillChange
                .sink { [weak self] _ in self?.objectWillChange.send() }
                .store(in: &cancellableSet)

            helpRequestCreationState.objectWillChange
                .sink { [weak self] _ in self?.objectWillChange.send() }
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
