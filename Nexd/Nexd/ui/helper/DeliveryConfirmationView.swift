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
            ScrollView {
                VStack(alignment: .leading) {
                    NexdUI.Headings.title(text: R.string.localizable.delivery_confirmation_screen_title.text)
                        .padding(.top, 109)
                        .padding([.leading, .trailing], 28)

                    ForEach(viewModel.requests, id: \.requestId) { request in
                        VStack {
                            NexdUI.Headings.h2Dark(text: Text(R.string.localizable.delivery_confirmation_section_header(request.requester)))
                                .padding(.top, 26)
                                .padding([.leading, .trailing], 28)

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

                    NexdUI.Buttons.default(text: R.string.localizable.delivery_confirmation_confirm_button_title.text) {
                        self.viewModel.continueButtonTapped()
                    }
                    .padding(.top, 46)
                    .padding(.bottom, 127)
                    .padding([.leading, .trailing], 28)
                }
                .background(R.color.nexdGreen.color)
            }
    }
}

extension DeliveryConfirmationView {
    class ViewModel: ObservableObject {
        let navigator: ScreenNavigating
        let helpList: HelpList
        let helpListsService: HelpListsService

        private var cancellableSet = Set<AnyCancellable>()

        var requests: [Request] {
            helpList.helpRequests.map { helpRequest -> Request in
                Request.from(helpRequest: helpRequest)
            }
        }

        init(navigator: ScreenNavigating, helpList: HelpList, helpListsService: HelpListsService) {
            self.navigator = navigator
            self.helpList = helpList
            self.helpListsService = helpListsService
        }

        func continueButtonTapped() {
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
            let viewModel = DeliveryConfirmationView.ViewModel(navigator: PreviewNavigator(), helpList: HelpList.with(), helpListsService: HelpListsService())
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
