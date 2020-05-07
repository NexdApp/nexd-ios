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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        return VStack {
            Group {
                NexdUI.Buttons.back(text: R.string.localizable.back_button_title.text) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                    .frame(maxWidth: .infinity, maxHeight: 20, alignment: .leading)
                    .padding(.top, 22)
                    .offset(x: -12)

                NexdUI.Texts.title(text: R.string.localizable.transcribe_articles_screen_title.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 29)

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
    }

    static func createScreen(viewModel: TranscribeListView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: TranscribeListView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}

extension TranscribeListView {
    struct ListItem: Identifiable {
        let id: Int64
        let title: String
        let amount: Int64
    }

    class ViewModel: ObservableObject {
        class ViewState: ObservableObject {
            @Published var isPlaying: Bool = false
            @Published var progress: Double = 0
            @Published var firstName: String = ""

            @Published var listItems: [ListItem] = []
        }

        private let navigator: ScreenNavigating
        private let articlesService: ArticlesService
        private let phoneService: PhoneService
        private let player: AudioPlayer?
        private let call: Call?
        private let transcribedRequest: HelpRequestCreateDto

        private var cancellableSet: Set<AnyCancellable>?
        var state = ViewState()

        func onPlayPause() {
            state.isPlaying ? player?.pause() : player?.play()
        }

        func onSliderMoved(to progress: Double) {
            player?.seekTo(progress: Float(progress))
        }

        func onAmountChanged(for listItem: ListItem, to amount: Int) {
            state.listItems = state.listItems.map { item -> ListItem in
                guard listItem.id == item.id else { return item }
                return ListItem(id: item.id, title: item.title, amount: Int64(amount))
            }
        }

        func onConfirmButtonPressed() {
            guard let call = call else {
                log.error("No call object found!")
                return
            }

            var dto = transcribedRequest
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
             player: AudioPlayer?,
             call: Call?,
             transcribedRequest: HelpRequestCreateDto) {
            self.navigator = navigator
            self.articlesService = articlesService
            self.phoneService = phoneService
            self.player = player
            self.call = call
            self.transcribedRequest = transcribedRequest
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
                .map { articles -> [ListItem] in
                    articles.map { ListItem(id: $0.id, title: $0.name, amount: 0) }
                }
                .assign(to: \.listItems, on: state)
                .store(in: &cancellableSet)

            player?.state.publisher
                .map { $0.isPlaying }
                .removeDuplicates()
                .receive(on: RunLoop.main)
                .replaceError(with: false)
                .assign(to: \.isPlaying, on: state)
                .store(in: &cancellableSet)

            player?.state.publisher
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
