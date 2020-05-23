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
                NexdUI.Texts.title(text: R.string.localizable.transcribe_articles_screen_title.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 70)

                NexdUI.Player(isPlaying: $viewModel.state.isPlaying,
                              progress: $viewModel.state.progress,
                              onPlayPause: { self.viewModel.onPlayPause() },
                              onProgressEdited: { progress in self.viewModel.onSliderMoved(to: progress) })

                List(viewModel.state.listItems) { listItem in
                    HStack {
                        HStack {
                            Text(listItem.title)
                                .font(R.font.proximaNovaSoftMedium.font(size: 18))
                                .foregroundColor(R.color.listItemTitle.color)
                                .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .leading)
                                .padding(.leading, 14)
                        }
                        .padding(.trailing, 14)
                        .background(Color.white)
                        .cornerRadius(10)

                        NexdUI.NumberInputView(text: String(listItem.amount),
                                               onValueConfirmed: { amount in
                                                   self.viewModel.onAmountChanged(for: listItem, to: amount)
                        })
                            .font(R.font.proximaNovaSoftBold.font(size: 20))
                            .foregroundColor(R.color.amountText.color)
                            .frame(width: 37, height: 37, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(18.5)
                    }
                }

                NexdUI.Buttons.default(text: R.string.localizable.transcribe_articles_button_title_confirm.text) {
                    self.viewModel.onConfirmButtonPressed()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 33)
                .padding(.bottom, 53)
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

        private var cancellableSet: Set<AnyCancellable>?

        func onBackButtonPressed() {
            navigator.goBack()
        }

        func onPlayPause() {
            state.isPlaying ? state.player?.pause() : state.player?.play()
        }

        func onSliderMoved(to progress: Double) {
            state.player?.seekTo(progress: Float(progress))
        }

        func onAmountChanged(for listItem: TranscribeViewState.ListItem, to amount: Int) {
            state.listItems = state.listItems.map { item -> TranscribeViewState.ListItem in
                guard listItem.id == item.id else { return item }
                return TranscribeViewState.ListItem(id: item.id, title: item.title, amount: Int64(amount))
            }
        }

        func onConfirmButtonPressed() {
            guard let call = state.call else {
                log.error("No call object found!")
                return
            }

            var dto = state.createDto()
            dto.articles = state.listItems.filter { item in item.amount > 0 }
                .map { CreateHelpRequestArticleDto(articleId: $0.id, articleName: nil, language: nil, articleCount: $0.amount, unitId: nil) }

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

        init(navigator: ScreenNavigating,
             articlesService: ArticlesService,
             phoneService: PhoneService,
             state: TranscribeViewState) {
            self.navigator = navigator
            self.articlesService = articlesService
            self.phoneService = phoneService
            self.state = state
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()
            articlesService.allArticles()
                .asObservable()
                .concat(Observable.never())
                .share(replay: 1, scope: .whileConnected)
                .publisher
                .receive(on: RunLoop.main)
                .replaceError(with: [])
                .map { articles -> [TranscribeViewState.ListItem] in
                    articles.map { [weak self] article in
                        if let item = self?.state.listItems.first(where: { article.id == $0.id }) {
                            return item
                        }
                        return TranscribeViewState.ListItem(id: article.id, title: article.name, amount: 0)
                    }
                }
                .assign(to: \.listItems, on: state)
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
                .sink { [weak self] in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellableSet)

            self.cancellableSet = cancellableSet
        }

        func unbind() {
            cancellableSet = nil
        }
    }
}
