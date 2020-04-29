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
            NexdUI.Headings.title(text: Text(viewModel.title))
                .padding([.leading, .trailing], 25)
                .padding(.top, 70)

            ScrollView {
                NexdUI.Card {
                    VStack {
                        ForEach(viewModel.articles) { item in
                            HStack {
                                Text(item.title)
                                    .padding(.trailing, 8)
                                    .font(R.font.proximaNovaSoftBold.font(size: 18))
                                    .foregroundColor(R.color.listItemTitle.color)

                                Spacer()

                                Text("\(item.amount)x")
                                    .font(R.font.proximaNovaSoftBold.font(size: 14))
                                    .foregroundColor(R.color.listItemDetailsText.color)
                            }
                            .frame(height: 52)
                        }
                    }
                    .padding([.top, .bottom], 8)
                }
                .padding([.top, .bottom], 24)
                .padding([.leading, .trailing], 12)
            }

            NexdUI.Buttons.lightButton(text: viewModel.type.buttonTitle) {
                self.viewModel.confirmButtonTapped()
            }
            .padding([.leading, .trailing], 12)
            .padding(.bottom, 24)
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
        private let helpRequest: HelpRequest
        private var helpList: HelpList
        private let onFinished: (HelpList) -> Void

        private var cancellableSet = Set<AnyCancellable>()

        var title: String {
            helpRequest.displayName
        }

        var articles: [ArticleItem] {
            helpRequest.articles?.compactMap { helpRequestArticle -> ArticleItem? in
                guard let id = helpRequestArticle.articleId, let article = helpRequestArticle.article, let amount = helpRequestArticle.articleCount else { return nil }

                return ArticleItem(id: id, title: article.name, amount: amount)
            } ?? []
        }

        init(type: ViewType,
             navigator: ScreenNavigating,
             helpListService: HelpListsService,
             helpRequest: HelpRequest,
             helpList: HelpList,
             onFinished: @escaping ((HelpList) -> Void)) {
            self.type = type
            self.navigator = navigator
            self.helpListService = helpListService
            self.helpRequest = helpRequest
            self.helpList = helpList
            self.onFinished = onFinished
        }

        func confirmButtonTapped() {
            let helpListsService = helpListService
            guard let requestId = helpRequest.id else { return }

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
            onFinished(helpList)
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
