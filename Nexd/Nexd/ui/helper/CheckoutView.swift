//
//  CheckoutView.swift
//  nexd
//
//  Created by Tobias Schröpf on 03.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            NexdUI.Texts.title(text: R.string.localizable.checkout_screen_title.text)
                .padding(.top, 70)

            OptionalView(viewModel.requests) { requests in
                List {
                    ForEach(requests, id: \.requestId) { request in
                        VStack(alignment: .leading) {
                            NexdUI.Texts.sectionHeader(text: Text(request.title))
                                .font(R.font.proximaNovaSoftBold.font(size: 35))
                                .foregroundColor(.white)

                            NexdUI.Card {
                                VStack {
                                    ForEach(request.articles, id: \.itemId) { article in
                                        HStack {
                                            NexdUI.Texts.cardText(text: Text(article.name))
                                                .font(R.font.proximaNovaSoftRegular.font(size: 18))
                                                .foregroundColor(R.color.listItemTitle.color)
                                                .frame(height: 52)

                                            Spacer()

                                            article.amountItem.map { amountItem in
                                                NexdUI.Texts.cardPlaceholderText(text: Text(amountItem.description))
                                                    .font(R.font.proximaNovaSoftRegular.font(size: 14))
                                                    .foregroundColor(R.color.listItemDetailsText.color)
                                                    .frame(height: 52)
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding(8)
                            }
                        }
                    }
                }
            }

            Spacer()

            NexdUI.Buttons.default(text: R.string.localizable.checkout_button_title_complete.text) {
                self.viewModel.completeButtonTapped()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 0)
            .padding(.bottom, 40)
        }
        .padding([.leading, .trailing], 20)
        .withBackButton { self.viewModel.backButtonTapped() }
    }
}

extension CheckoutView {
    struct Request {
        let requestId: Int
        let title: String
        let articles: [Item]
    }

    struct Item {
        let itemId: Int64
        let name: String
        let amountItem: HelperWorkflowState.AmountItem?
    }

    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating
        private let helperWorkflowState: HelperWorkflowState

        var requests: [Request]? {
            helperWorkflowState.helpList?.helpRequests.map { helpRequest -> Request in
                Request(requestId: Int(helpRequest.id ?? 0),
                        title: helpRequest.firstName ?? "-",
                        articles: helpRequest.articles?.compactMap {
                            guard let article = $0.article else { return nil }
                            return Item(itemId: article.id, name: article.name, amountItem: helperWorkflowState.amountItem(for: $0))
                } ?? [])
            }
        }

        init(navigator: ScreenNavigating, helperWorkflowState: HelperWorkflowState) {
            self.navigator = navigator
            self.helperWorkflowState = helperWorkflowState
        }

        func backButtonTapped() {
            navigator.goBack()
        }

        func completeButtonTapped() {
            navigator.toDeliveryConfirmationScreen(helperWorkflowState: helperWorkflowState)
        }

        func goShoppingTapped() {
            navigator.toHelperOverview()
        }
    }

    static func createScreen(viewModel: CheckoutView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: CheckoutView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}
