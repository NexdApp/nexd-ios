//
//  EditOpenHelpRequestsView.swift
//  nexd
//
//  Created by Tobias Schröpf on 26.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import NexdClient
import RxRelay
import RxSwift
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
                                OptionalView(request.createdAt?.displayString) { displayString in
                                    NexdUI.Texts.sectionHeader(text: Text(displayString))
                                        .font(R.font.proximaNovaBold.font(size: 35))
                                        .foregroundColor(.white)
                                }

                                NexdUI.Card {
                                    VStack(alignment: .leading) {
                                        OptionalView(request.articles) { articles in
                                            NexdUI.ShoppingList(items: articles, units: self.viewModel.state.units, onTapped: nil)
                                        }

                                        Divider()

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

                                        if request.status == .pending {
                                            NexdUI.Buttons.lightButton(text: R.string.localizable.edit_open_help_requests_cancel_request_button_title.text, icon: nil) {
                                                self.viewModel.cancel(helpRequest: request)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(20)
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
            @Published var units: [NexdClient.Unit]?
        }

        private let listUpdateTrigger = BehaviorRelay<Void>(value: ())
        private let navigator: ScreenNavigating
        private let helpRequestsService: HelpRequestsService
        private let articlesService: ArticlesService
        private var cancellableSet = Set<AnyCancellable>()

        fileprivate var state: ViewState = ViewState()

        init(navigator: ScreenNavigating, helpRequestsService: HelpRequestsService, articlesService: ArticlesService) {
            self.navigator = navigator
            self.helpRequestsService = helpRequestsService
            self.articlesService = articlesService
        }

        func backButtonTapped() {
            navigator.goBack()
        }

        func cancel(helpRequest: HelpRequest) {
            guard let requestId = helpRequest.id else { return }
            let dto = HelpRequestCreateDto(firstName: nil,
                                           lastName: nil,
                                           street: nil,
                                           number: nil,
                                           zipCode: nil,
                                           city: nil,
                                           articles: nil,
                                           status: .deactivated,
                                           additionalRequest: nil,
                                           deliveryComment: nil,
                                           phoneNumber: nil)
            helpRequestsService.updateRequest(requestId: requestId, dto: dto)
                .publisher
                .sink(receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        log.error("Updating help request failed: \(error)")

                        self?.navigator.showError(title: R.string.localizable.edit_open_help_requests_cancel_request_error_title(),
                                                  message: R.string.localizable.edit_open_help_requests_cancel_request_error_message(),
                                                  handler: nil)

                        return
                    }

                    self?.listUpdateTrigger.accept(())
                },
                      receiveValue: { _ in })
                .store(in: &cancellableSet)
        }

        func bind() {
            let helpRequestService = helpRequestsService

            listUpdateTrigger
                .flatMapLatest { _ -> Observable<[HelpRequest]> in
                    Observable.combineLatest(
                        helpRequestService.openRequests(userId: "me", excludeUserId: false, includeRequester: false, status: [.ongoing]).asObservable(),
                        helpRequestService.openRequests(userId: "me", excludeUserId: false, includeRequester: false, status: [.pending]).asObservable()
                    ) { ongoingRequests, pendingRequests -> [HelpRequest] in
                        var merged = ongoingRequests + pendingRequests
                        merged
                            .sort {
                                guard let first = $0.createdAt else { return false }
                                guard let second = $1.createdAt else { return true }
                                return first > second
                            }
                        return merged
                    }
                }
                .map { requests -> [HelpRequest]? in
                    requests.isEmpty ? nil : requests
                }
                .publisher
                .replaceError(with: nil)
                .assign(to: \.myRequests, on: state)
                .store(in: &cancellableSet)

            articlesService.allUnits()
                .map { units -> [NexdClient.Unit]? in units }
                .publisher
                .replaceError(with: nil)
                .assign(to: \.units, on: state)
                .store(in: &cancellableSet)

            state.objectWillChange
                .sink { [weak self] _ in self?.objectWillChange.send() }
                .store(in: &cancellableSet)
        }

        func unbind() {
            cancellableSet = Set<AnyCancellable>()
        }
    }

    static func createScreen(viewModel: EditOpenHelpRequestsView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: EditOpenHelpRequestsView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}
