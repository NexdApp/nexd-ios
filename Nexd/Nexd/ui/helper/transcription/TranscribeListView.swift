//
//  TranscribeListView.swift
//  nexd
//
//  Created by Tobias Schröpf on 16.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import NexdClient
import RxSwift
import SwiftUI

struct TranscribeListView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        return VStack {
            Group {
                NexdUI.Player(isPlaying: $viewModel.state.isPlaying,
                              progress: $viewModel.state.progress,
                              onPlayPause: { self.viewModel.onPlayPause() },
                              onProgressEdited: { progress in self.viewModel.onSliderMoved(to: progress) })
                    .padding(.top, 70)

                HStack {
                    NexdUI.Texts.title(text: R.string.localizable.transcribe_articles_screen_title.text)

                    Spacer()

                    NexdUI.Buttons.addButton {
                        self.viewModel.addItemEntryTapped()
                    }
                }

                ScrollView {
                    if viewModel.helpRequestCreationState.items.isEmpty {
                        NexdUI.Texts.detailsText(text: R.string.localizable.transcribe_articles_selection_no_items_text.text)

                        R.image.nexdIllustration3.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .padding(.top, 40)
                            .background(Circle().fill(Color.white))
                    } else {
                        NexdUI.EditableArticleList(items: viewModel.helpRequestCreationState.items,
                                                   onDelete: { self.viewModel.removeItem(item: $0) },
                                                   onEdit: { self.viewModel.editItem(item: $0) })
                    }
                }

                NexdUI.Buttons.default(text: R.string.localizable.transcribe_articles_button_title_confirm.text) {
                    self.viewModel.onConfirmButtonPressed()
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
        .onAppear { self.viewModel.bind() }
        .onDisappear { self.viewModel.unbind() }
        .withBackButton { self.viewModel.onBackButtonPressed() }
    }

    static func createScreen(viewModel: TranscribeListView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: TranscribeListView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}

extension TranscribeListView {
    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating
        private let articlesService: ArticlesService
        private let phoneService: PhoneService

        fileprivate var state: TranscribeViewState
        fileprivate var helpRequestCreationState: HelpRequestCreationState

        private var cancellableSet: Set<AnyCancellable>?

        init(navigator: ScreenNavigating,
             articlesService: ArticlesService,
             phoneService: PhoneService,
             state: TranscribeViewState) {
            self.navigator = navigator
            self.articlesService = articlesService
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

        func addItemEntryTapped() {
            navigator.toArticleInput(helpRequestCreationState: helpRequestCreationState, with: nil) { [weak self] item in
                self?.helpRequestCreationState.items.append(item)
            }
        }

        func editItem(item: HelpRequestCreationState.Item) {
            navigator.toArticleInput(helpRequestCreationState: helpRequestCreationState, with: item) { [weak self] updatedtem in
                guard let self = self else { return }

                log.debug("Item updated: \(updatedtem)")
                guard let existingItem = self.helpRequestCreationState.items.firstIndex(where: { $0.id == item.id }) else {
                    self.helpRequestCreationState.items.append(updatedtem)
                    return
                }

                self.helpRequestCreationState.items[existingItem] = updatedtem
            }
        }

        func removeItem(item: HelpRequestCreationState.Item) {
            helpRequestCreationState.items.removeAll { $0.id == item.id }
        }

        func onConfirmButtonPressed() {
            guard let call = state.call else {
                log.error("No call object found!")
                return
            }

            let dto = helpRequestCreationState.dto

            cancellableSet?.insert(
                phoneService.convertCallToHelpRequest(sid: call.sid, dto: dto)
                    .publisher
                    .sink(receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            log.error("Creating help request failed: \(error)")

                            self.navigator.showError(title: R.string.localizable.transcribe_articles_error_title(),
                                                     message: R.string.localizable.transcribe_articles_error_message(),
                                                     handler: nil)

                            return
                        }

                        self.navigator.toTranscribeEndView()
                    },
                          receiveValue: { _ in })
            )
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

            articlesService
                .allUnits(language: helpRequestCreationState.language)
                .publisher
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        log.error("Loading units failed: \(error)")
                        return
                    }
                }, receiveValue: { [weak self] units in
                    log.debug("Received units: \(units)")
                    self?.helpRequestCreationState.units = units
                        .sorted { first, second -> Bool in first.name < second.name }
                        .map { unit in HelpRequestCreationState.Unit(id: unit.id, name: unit.name, nameShort: unit.nameShort) }
                })
                .store(in: &cancellableSet)

            state.player?.state.publisher
                .map { $0.isPlaying }
                .removeDuplicates()
                .receive(on: RunLoop.main)
                .replaceError(with: false)
                .assign(to: \.isPlaying, on: state)
                .store(in: &cancellableSet)

            state.player?.state.publisher
                .map { $0.progress ?? 0 }
                .removeDuplicates()
                .receive(on: RunLoop.main)
                .replaceError(with: 0)
                .assign(to: \.progress, on: state)
                .store(in: &cancellableSet)

            state.objectWillChange
                .sink { [weak self] in self?.objectWillChange.send() }
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
}
