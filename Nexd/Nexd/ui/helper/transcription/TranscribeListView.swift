//
//  TranscribeListView.swift
//  nexd
//
//  Created by Tobias Schröpf on 16.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import NexdClient
import SwiftUI

extension Article: Identifiable {}

struct TranscribeListView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        return VStack {
            Group {
                HStack {
                    Spacer()
                }
                NexdUI.Headings.title(text: R.string.localizable.transcribe_articles_screen_title.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 71)

                NexdUI.Player(isPlaying: $viewModel.state.isPlaying,
                              progress: $viewModel.state.progress,
                              onPlayPause: { self.viewModel.onPlayPause() },
                              onProgressEdited: { progress in self.viewModel.onSliderMoved(to: progress) })

                List(viewModel.state.articles) { article in
                    HStack {
                        HStack {
                            Text(article.name)
                                .font(R.font.proximaNovaSoftMedium.font(size: 18))
                                .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .leading)
                                .padding(.leading, 14)
                        }
                        .padding(.trailing, 14)
                        .background(Color.white)
                        .cornerRadius(10)

                        NexdUI.NumberInputView(onValueConfirmed: { value in
                        log.debug("TODO: Save to view model -> refresh list: \(value)")
                        })
                            .font(R.font.proximaNovaSoftBold.font(size: 20))
                            .foregroundColor(R.color.amountText.color)
                            .frame(width: 37, height: 37, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(18.5)
                    }
                }

                NexdUI.Buttons.default(text: R.string.localizable.transcribe_articles_button_title_confirm.text) {
                    log.debug("IMPLEMENT ME!!!")
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
//        .dismissingKeyboard()
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
    class ViewModel: ObservableObject {
        class ViewState: ObservableObject {
            @Published var isPlaying: Bool = false
            @Published var progress: Double = 0
            @Published var firstName: String = ""

            @Published var articles: [Article] = []
        }

        let navigator: ScreenNavigating
        private let articlesService: ArticlesService
        private let player: AudioPlayer

        private var cancellableSet: Set<AnyCancellable>?
        var state = ViewState()

        func onPlayPause() {
            state.isPlaying ? player.pause() : player.play()
        }

        func onSliderMoved(to progress: Double) {
            player.seekTo(progress: Float(progress))
        }

        init(navigator: ScreenNavigating, articlesService: ArticlesService) {
            self.navigator = navigator
            self.articlesService = articlesService
            player = AudioPlayer.sampleMp3()
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()
            articlesService.allArticles()
                .asObservable()
                .share(replay: 1, scope: .whileConnected)
                .publisher
                .receive(on: RunLoop.main)
                .replaceError(with: [])
                .assign(to: \.articles, on: state)
                .store(in: &cancellableSet)

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
}

#if DEBUG
    struct TranscribeListView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                TranscribeListView(viewModel: TranscribeListView.ViewModel(navigator: PreviewNavigator(), articlesService: ArticlesService()))
                    .environment(\.colorScheme, .light)

                TranscribeListView(viewModel: TranscribeListView.ViewModel(navigator: PreviewNavigator(), articlesService: ArticlesService()))
                    .environment(\.colorScheme, .dark)
            }
            .background(R.color.nexdGreen.color)
            .previewLayout(.sizeThatFits)
        }
    }
#endif
