//
//  ShoppingListView.swift
//  nexd
//
//  Created by Tobias Schröpf on 02.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import SwiftUI

struct ShoppingListView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            NexdUI.Texts.title(text: R.string.localizable.shopping_list_screen_title.text)
                .padding(.top, 70)

            ScrollView {
                NexdUI.Card {
                    OptionalView(viewModel.articles) { articles in
                        ForEach(articles) { article in
                            VStack {
                                NexdUI.Texts.cardText(text: Text(article.name).strikethrough(self.viewModel.isArticleFinished(article: article), color: .black))
                                    .padding([.leading, .trailing], 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                OptionalView(self.viewModel.amountItems(for: article)) { amountItems in
                                    ForEach(amountItems) { amountItem in
                                        NexdUI.Texts.cardPlaceholderText(text: Text(amountItem.description)
                                            .strikethrough(self.viewModel.isArticleFinished(article: article), color: .black))
                                            .padding([.leading, .trailing], 24)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .onTapGesture {
                                self.viewModel.articleTapped(article: article)
                            }

                            Divider()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            NexdUI.Buttons.default(text: R.string.localizable.shopping_list_button_title_checkout.text) {
                self.viewModel.checkoutButtonTapped()
            }
            .identified(by: .shoppingListContinueButton)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 0)
            .padding(.bottom, 40)
        }
        .padding([.leading, .trailing], 20)
        .withBackButton { self.viewModel.backButtonTapped() }
    }
}

extension ShoppingListView {
    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating
        private let helperWorkflowState: HelperWorkflowState

        @Published var finishedArticles = [Article]()

        var articles: [Article]? {
            groupedArticles?.keys.compactMap { $0 }.sorted()
        }

        private var groupedArticles: [Article?: [NexdClient.HelpRequestArticle]]? {
            guard let helpRequests = helperWorkflowState.helpList?.helpRequests else { return nil }

            let articles = helpRequests
                .compactMap { request -> [HelpRequestArticle]? in request.articles }
                .flatMap { articles -> [HelpRequestArticle] in articles }

            return Dictionary(grouping: articles, by: { $0.article })
        }

        init(navigator: ScreenNavigating, helperWorkflowState: HelperWorkflowState) {
            self.navigator = navigator
            self.helperWorkflowState = helperWorkflowState
        }

        func backButtonTapped() {
            navigator.goBack()
        }

        func checkoutButtonTapped() {
            navigator.toCheckoutScreen(helperWorkflowState: helperWorkflowState)
        }

        func amountItems(for article: Article) -> [HelperWorkflowState.AmountItem]? {
            let helpRequestArticles = groupedArticles?[article]

            return helpRequestArticles?.compactMap { helpRequestArticle -> HelperWorkflowState.AmountItem? in
                helperWorkflowState.amountItem(for: helpRequestArticle)
            }
        }

        func articleTapped(article: Article) {
            if isArticleFinished(article: article) {
                finishedArticles.removeAll { $0.id == article.id }
            } else {
                finishedArticles.append(article)
            }
        }

        func isArticleFinished(article: Article) -> Bool {
            finishedArticles.contains(article)
        }
    }

    static func createScreen(viewModel: ShoppingListView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: ShoppingListView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}
