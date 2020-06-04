//
//  RequestDetailsView.swift
//  nexd
//
//  Created by Tobias Schröpf on 26.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import NexdClient
import RxSwift
import SwiftUI

struct RequestDetailsView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            NexdUI.Texts.title(text: Text(viewModel.helpRequest.displayName))
                .padding([.leading, .trailing], 25)
                .padding(.top, 70)

            ScrollView {
                Group {
                    NexdUI.Card {
                        VStack(alignment: .leading) {
                            NexdUI.Texts.cardSectionHeader(text: R.string.localizable.helper_request_detail_screen_title.text)
                                .padding([.leading, .trailing, .bottom], 12)

                            OptionalView(viewModel.articles) { articles in
                                NexdUI.ShoppingList(items: articles, units: self.viewModel.units, onTapped: nil)
                            }
                            .whenNil {
                                NexdUI.Texts.cardPlaceholderText(text: R.string.localizable.helper_request_detail_empty_list_placeholder.text)
                            }
                            .padding([.leading, .trailing], 24)

                            OptionalView(viewModel.helpRequest.additionalRequest) { additionalRequest in
                                NexdUI.Texts.cardSectionHeader(text: R.string.localizable.helper_request_detail_additional_request_header.text)
                                    .padding(.top, 24)
                                    .padding([.leading, .trailing, .bottom], 12)

                                NexdUI.Texts.cardText(text: Text(additionalRequest))
                                    .lineLimit(nil)
                                    .padding([.leading, .trailing], 24)
                            }
                        }
                        .padding([.top, .bottom], 8)
                    }
                    .padding([.top, .bottom], 8)

                    NexdUI.Card {
                        VStack(alignment: .leading) {
                            NexdUI.Texts.cardSectionHeader(text: R.string.localizable.helper_request_detail_delivery_address_header.text)
                                .padding([.leading, .trailing, .bottom], 12)

                            OptionalView(viewModel.helpRequest.displayAddress) { address in
                                NexdUI.Texts.cardText(text: Text(address))
                            }
                            .whenNil {
                                NexdUI.Texts.cardPlaceholderText(text: R.string.localizable.helper_request_detail_empty_delivery_address_placeholder.text)
                            }
                            .padding([.leading, .trailing], 24)

                            OptionalView(viewModel.helpRequest.deliveryComment) { deliveryComment in
                                NexdUI.Texts.cardSectionHeader(text: R.string.localizable.helper_request_detail_delivery_comment_header.text)
                                    .padding(.top, 24)
                                    .padding([.leading, .trailing, .bottom], 12)

                                NexdUI.Texts.cardText(text: Text(deliveryComment))
                                    .padding([.leading, .trailing], 24)
                            }
                        }
                        .padding([.top, .bottom], 8)
                    }
                    .padding([.top, .bottom], 8)
                }
                .padding([.leading, .trailing], 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            NexdUI.Buttons.lightButton(text: viewModel.type.buttonTitle) {
                self.viewModel.confirmButtonTapped()
            }
            .padding([.leading, .trailing], 12)
            .padding(.bottom, 24)
        }
        .withCancelButton {
            self.viewModel.cancelButtonTapped()
        }
    }
}

extension RequestDetailsView {
    enum ViewType {
        case addRequestToHelpList
        case removeRequestFromHelpList

        var buttonTitle: Text {
            switch self {
            case .addRequestToHelpList:
                return R.string.localizable.helper_request_detail_button_accept.text

            case .removeRequestFromHelpList:
                return R.string.localizable.helper_request_detail_button_remove.text
            }
        }
    }

    class ViewModel: ObservableObject {
        struct ArticleItem: Identifiable {
            let id: Int64
            let title: String
            let amount: Int64
        }

        fileprivate let type: ViewType
        private let navigator: ScreenNavigating
        private let helpListService: HelpListsService

        fileprivate let helpRequest: HelpRequest
        private var helperWorkflowState: HelperWorkflowState

        private let onFinished: (HelpList) -> Void
        private let onCancelled: () -> Void

        private var cancellableSet = Set<AnyCancellable>()

        var articles: [HelpRequestArticle]? {
            guard let articles = helpRequest.articles, !articles.isEmpty else {
                return nil
            }

            return articles
        }

        var units: [NexdClient.Unit]? {
            helperWorkflowState.units
        }

        init(type: ViewType,
             navigator: ScreenNavigating,
             helpListService: HelpListsService,
             helpRequest: HelpRequest,
             helperWorkflowState: HelperWorkflowState,
             onFinished: @escaping ((HelpList) -> Void),
             onCancelled: @escaping (() -> Void)) {
            self.type = type
            self.navigator = navigator
            self.helpListService = helpListService
            self.helpRequest = helpRequest
            self.helperWorkflowState = helperWorkflowState
            self.onFinished = onFinished
            self.onCancelled = onCancelled
        }

        func cancelButtonTapped() {
            onCancelled()
        }

        func confirmButtonTapped() {
            let helpListsService = helpListService
            guard let requestId = helpRequest.id else { return }

            guard let helpList = helperWorkflowState.helpList else {
                log.error("There is not helpList for this operation!")
                return
            }

            let publisher = type == .addRequestToHelpList ?
                helpListsService.addRequest(withId: requestId, to: helpList.id).publisher :
                helpListsService.removeRequest(withId: requestId, from: helpList.id).publisher

            return publisher
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        log.error("Help List request failed: \(error)")
                        return
                    }
                }, receiveValue: { [weak self] helpList in
                    self?.onFinished(helpList)
                })
                .store(in: &cancellableSet)
        }

        fileprivate func onModalDismissed() {
            onCancelled()
        }
    }

    static func createScreen(viewModel: RequestDetailsView.ViewModel) -> ModalScreen<RequestDetailsView> {
        let screen = ModalScreen(rootView: RequestDetailsView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        screen.onDismiss = {
            viewModel.onModalDismissed()
        }
        return screen
    }
}
