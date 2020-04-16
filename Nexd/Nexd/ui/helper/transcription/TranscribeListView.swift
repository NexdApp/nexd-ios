//
//  TranscribeListView.swift
//  nexd
//
//  Created by Tobias Schröpf on 16.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import SwiftUI
import NexdClient

extension Article: Identifiable {

}

struct TranscribeListView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        return VStack {
            Group {
                NexdUI.Headings.title(text: R.string.localizable.transcribe_info_screen_title.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 71)

                ForEach(viewModel.state.articles) { article in
                    Text(article.name)
                }
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
