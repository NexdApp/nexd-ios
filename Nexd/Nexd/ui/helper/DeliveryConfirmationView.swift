//
//  DeliveryConfirmationView.swift
//  nexd
//
//  Created by Tobias Schröpf on 13.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import NexdClient
import Rswift
import SwiftUI

struct DeliveryConfirmationView: View {
    struct Request {
        let requestId: Int64
        let requester: String
        let phoneNumber: String
        let address: String

        static func from(helpRequest: HelpRequest) -> Request {
            Request(requestId: helpRequest.id ?? 0,
                    requester: helpRequest.firstName ?? "-",
                    phoneNumber: helpRequest.phoneNumber ?? "-",
                    address: "\(helpRequest.zipCode ?? "-") / \(helpRequest.city ?? "-")")
        }
    }

    var viewModel: ViewModel

    var body: some View {
        return
            VStack {
                NexdUI.Texts.title(text: R.string.localizable.delivery_confirmation_screen_title.text)
                    .padding(.top, 70)

                ScrollView {
                    VStack(alignment: .leading) {
                        OptionalView(viewModel.requests) { requests in
                            ForEach(requests, id: \.requestId) { request in
                                VStack {
                                    NexdUI.Texts.sectionHeader(text: Text(R.string.localizable.delivery_confirmation_section_header(request.requester)))
                                        .padding(.top, 26)

                                    NexdUI.Card {
                                        VStack {
                                            R.string.localizable.delivery_confirmation_phone_number_title.text
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .font(R.font.proximaNovaSoftBold.font(size: 18))
                                                .foregroundColor(R.color.darkListItemTitle.color)

                                            Text(request.phoneNumber)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                                .font(R.font.proximaNovaSoftRegular.font(size: 20))
                                                .foregroundColor(R.color.nexdGreen.color)

                                            Divider()

                                            R.string.localizable.delivery_confirmation_address_title.text
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .font(R.font.proximaNovaSoftBold.font(size: 18))
                                                .foregroundColor(R.color.darkListItemTitle.color)

                                            Text(request.address)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                                .font(R.font.proximaNovaSoftRegular.font(size: 20))
                                                .foregroundColor(R.color.nexdGreen.color)
                                        }
                                    }
                                    .padding([.leading, .trailing], 12)
                                }
                            }
                        }

                        NexdUI.Buttons.default(text: R.string.localizable.delivery_confirmation_confirm_button_title.text) {
                            self.viewModel.continueButtonTapped()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 0)
                        .padding(.bottom, 40)
                    }
                }
            }
            .padding([.leading, .trailing], 20)
            .withBackButton { self.viewModel.backButtonTapped() }
    }
}

extension DeliveryConfirmationView {
    class ViewModel: ObservableObject {
        let navigator: ScreenNavigating
        let helpList: HelpList?
        let helpListsService: HelpListsService

        private var cancellableSet = Set<AnyCancellable>()

        var requests: [Request]? {
            helpList?.helpRequests.map { helpRequest -> Request in
                Request.from(helpRequest: helpRequest)
            }
        }

        init(navigator: ScreenNavigating, helperWorkflowState: HelperWorkflowState, helpListsService: HelpListsService) {
            self.navigator = navigator
            helpList = helperWorkflowState.helpList
            self.helpListsService = helpListsService
        }

        func backButtonTapped() {
            navigator.goBack()
        }

        func continueButtonTapped() {
            guard let helpList = helpList else { return }

            cancellableSet.insert(
                helpListsService.completeHelpList(helpListId: helpList.id,
                                                  helpRequestsIds: helpList.helpRequests.compactMap { $0.id })
                    .publisher
                    .sink(receiveCompletion: { [weak self] completion in
                        if case let .failure(error) = completion {
                            log.error("Finishing the help list failed: \(error)")
                            return
                        }

                        self?.navigator.toMainScreen()
                    },
                          receiveValue: { _ in })
            )
        }
    }

    static func createScreen(viewModel: ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: DeliveryConfirmationView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}
