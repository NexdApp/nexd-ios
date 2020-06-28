//
//  EditOpenHelpRequestsView.swift
//  nexd
//
//  Created by Tobias Schröpf on 26.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import NexdClient
import SwiftUI

struct EditOpenHelpRequestsView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            NexdUI.Texts.title(text: R.string.localizable.edit_open_help_requests_screen_title.text)
                .padding(.top, 70)
                .padding([.leading, .trailing], 20)

            ScrollView {
                VStack(alignment: .leading) {
                    OptionalView(self.viewModel.state.myRequests as [HelpRequest]?) { requests in
                        ForEach(requests, id: \.id) { request in
                            VStack(alignment: .leading) {
                                NexdUI.Texts.sectionHeader(text: Text(request.createdAt?.displayString ?? "???"))
                                    .font(R.font.proximaNovaBold.font(size: 35))
                                    .foregroundColor(.white)

                                NexdUI.Card {
                                    OptionalView(request.displayStatus) { displayStatus in
                                        HStack {
                                            NexdUI.Texts.cardText(text: R.string.localizable.edit_open_help_requests_request_status_title.text)
                                                .font(R.font.proximaNovaRegular.font(size: 18))
                                                .foregroundColor(R.color.listItemTitle.color)
                                                .frame(height: 52)

                                            Spacer()

                                            NexdUI.Texts.cardPlaceholderText(text: Text(displayStatus))
                                                .font(R.font.proximaNovaRegular.font(size: 14))
                                                .foregroundColor(R.color.listItemDetailsText.color)
                                                .frame(height: 52)
                                        }
                                    }

                                    OptionalView(request.articles) { articles in
                                        VStack {
                                            ForEach(articles) { helpRequestArticle in
                                                OptionalView(helpRequestArticle) { article in
                                                    NexdUI.ShoppingListItemView(item: article, unit: article.unit, onTapped: {})
                                                }
                                            }
                                        }
                                        .padding(8)
                                    }
                                }
                            }
                        }
                    }
                    .whenNil {
                        NexdUI.Texts.detailsText(text: R.string.localizable.edit_open_help_requests_no_open_requests_placeholer.text)
                            .padding([.top, .bottom], 20)
                    }
                }
            }
        }
        .onAppear { self.viewModel.bind() }
        .onDisappear { self.viewModel.unbind() }
        .withBackButton { self.viewModel.backButtonTapped() }
    }
}

extension EditOpenHelpRequestsView {
    class ViewModel: ObservableObject {
        class ViewState: ObservableObject {
            @Published var myRequests: [HelpRequest]?
        }

        private let navigator: ScreenNavigating
        private let helpRequestsService: HelpRequestsService
        private var cancellableSet: Set<AnyCancellable>?

        fileprivate var state: ViewState = ViewState()

        init(navigator: ScreenNavigating, helpRequestsService: HelpRequestsService) {
            self.navigator = navigator
            self.helpRequestsService = helpRequestsService
        }

        func backButtonTapped() {
            navigator.goBack()
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

            helpRequestsService
                .openRequests(userId: "me", excludeUserId: false, includeRequester: false, status: [.pending])
                .map { requests -> [HelpRequest]? in
                    requests.isEmpty ? nil : requests
                }
                .publisher
                .replaceError(with: nil)
                .assign(to: \.myRequests, on: state)
                .store(in: &cancellableSet)

            state.objectWillChange
                .sink { [weak self] _ in self?.objectWillChange.send() }
                .store(in: &cancellableSet)

            self.cancellableSet = cancellableSet
        }

        func unbind() {
            cancellableSet = nil
        }
    }

    static func createScreen(viewModel: EditOpenHelpRequestsView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: EditOpenHelpRequestsView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}
