//
//  DeliveryConfirmationView.swift
//  nexd
//
//  Created by Tobias Schröpf on 13.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Rswift
import SwiftUI
import NexdClient

struct DeliveryConfirmationView: View {
    struct Request {
        let requestId: Int64
        let requester: String
        let phoneNumber: String
        let address: String

        static func from(helpRequest: HelpRequest) -> Request {
            Request(requestId: helpRequest.id ?? 0,
                    requester: helpRequest.requester?.firstName ?? "-",
                    phoneNumber: helpRequest.phoneNumber ?? "-",
                    address: "\(helpRequest.zipCode ?? "-") / \(helpRequest.city ?? "-")")
        }
    }

    struct ViewModel {
        let navigator: ScreenNavigating
        let helpList: HelpList

        var requests: [Request] {
            helpList.helpRequests.map { helpRequest -> Request in
                Request.from(helpRequest: helpRequest)
            }
        }

        func continueButtonTapped() {
            navigator.toMainScreen()
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

#if DEBUG
    struct DeliveryConfirmationView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = DeliveryConfirmationView.ViewModel(navigator: PreviewNavigator(), helpList: HelpList.with())
            return Group {
                DeliveryConfirmationView(viewModel: viewModel)
                    .environment(\.locale, .init(identifier: "de"))

                DeliveryConfirmationView(viewModel: viewModel)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                DeliveryConfirmationView(viewModel: viewModel)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
