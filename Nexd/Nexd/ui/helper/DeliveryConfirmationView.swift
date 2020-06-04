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
        let name: String?
        let phoneNumber: String?
        let address: String?
        let deliveryComment: String?

        static func from(helpRequest: HelpRequest) -> DeliveryConfirmationView.Request {
            Request(requestId: helpRequest.id ?? 0,
                    requester: helpRequest.displayName,
                    name: helpRequest.fullName,
                    phoneNumber: helpRequest.phoneNumber,
                    address: helpRequest.displayAddress,
                    deliveryComment: helpRequest.deliveryComment)
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
                                            OptionalView(request.name) { name in
                                                NexdUI.Texts.cardSectionHeader(text: R.string.localizable.delivery_confirmation_full_name.text)

                                                NexdUI.Texts.cardPlaceholderText(text: Text(name))
                                                    .frame(maxWidth: .infinity, alignment: .trailing)

                                                Divider()
                                            }

                                            OptionalView(request.address) { address in
                                                NexdUI.Texts.cardSectionHeader(text: R.string.localizable.delivery_confirmation_address_title.text)

                                                NexdUI.Texts.cardPlaceholderText(text: Text(address))
                                                    .frame(maxWidth: .infinity, alignment: .trailing)

                                                Divider()
                                            }

                                            OptionalView(request.phoneNumber) { phoneNumber in
                                                NexdUI.Texts.cardSectionHeader(text: R.string.localizable.delivery_confirmation_phone_number_title.text)

                                                NexdUI.Texts.cardPlaceholderText(text: Text(phoneNumber))
                                                    .frame(maxWidth: .infinity, alignment: .trailing)

                                                Divider()
                                            }

                                            OptionalView(request.deliveryComment) { deliveryComment in
                                                NexdUI.Texts.cardSectionHeader(text: R.string.localizable.delivery_confirmation_delivery_comment.text)

                                                NexdUI.Texts.cardPlaceholderText(text: Text(deliveryComment))
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                            }
                                        }
                                    }
                                    .padding(12)
                                }
                            }
                        }
                    }
                }

                Spacer()

                NexdUI.Buttons.default(text: R.string.localizable.delivery_confirmation_confirm_button_title.text) {
                    self.viewModel.continueButtonTapped()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 0)
                .padding(.bottom, 40)
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

        var requests: [DeliveryConfirmationView.Request]? {
            helpList?.helpRequests.map { helpRequest -> DeliveryConfirmationView.Request in
                DeliveryConfirmationView.Request.from(helpRequest: helpRequest)
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

#if DEBUG
    struct DeliveryConfirmationView_Previews: PreviewProvider {
        static var previews: some View {
            let helperWorkflowState = HelperWorkflowState()
            helperWorkflowState.helpList = HelpList(id: 1,
                                                    helpRequestsIds: [1, 2, 3],
                                                    ownerId: nil,
                                                    owner: nil,
                                                    createdAt: Date(),
                                                    updatedAt: Date(),
                                                    status: nil,
                                                    helpRequests: [HelpRequest(firstName: "First",
                                                                               lastName: "Last",
                                                                               street: "Street",
                                                                               number: "Number",
                                                                               zipCode: "ZIP code",
                                                                               city: "City",
                                                                               id: 1,
                                                                               helpListId: nil,
                                                                               createdAt: nil,
                                                                               priority: nil,
                                                                               additionalRequest: "Additional request",
                                                                               deliveryComment: "Delivery Comment",
                                                                               phoneNumber: "+4915112345678",
                                                                               status: nil,
                                                                               articles: nil,
                                                                               requesterId: nil,
                                                                               requester: nil,
                                                                               helpList: nil,
                                                                               callSid: nil)])
            let viewModel = DeliveryConfirmationView.ViewModel(navigator: PreviewNavigator(), helperWorkflowState: helperWorkflowState, helpListsService: HelpListsService())
            return Group {
                DeliveryConfirmationView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.locale, .init(identifier: "de"))

                DeliveryConfirmationView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                DeliveryConfirmationView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
