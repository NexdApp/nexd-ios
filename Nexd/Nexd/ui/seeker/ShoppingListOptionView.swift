//
//  ShoppingListOptionViewController.swift
//  nexd
//
//  Created by Tobias Schröpf on 10.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

// import Foundation
// import RxCocoa
// import RxSwift

import SwiftUI

struct ShoppingListOptionView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            NexdUI.Texts.title(text: R.string.localizable.seeker_type_screen_title.text)
                .padding(.top, 70)
                .padding([.leading, .trailing], 20)

            NexdUI.Buttons.darkMainMenuButton(text: R.string.localizable.seeker_type_button_help_request.text) {
                self.viewModel.selectItemsTapped()
            }
            .padding([.leading, .trailing], 12)

            //        Make Phone Call Button will be reenabled as soon as the hotline is getting better
            //        Check the issue: https://github.com/NexdApp/nexd-ios/issues/54
            //        scrollView.addSubview(makePhonecallButton)
//            NexdUI.Buttons.darkMainMenuButton(text: R.string.localizable.seeker_type_button_phone_call.text) {
//                self.viewModel.makePhoneCallTapped()
//            }
//            .padding([.leading, .trailing], 12)

            Spacer()
        }
        .withBackButton { self.viewModel.backButtonTapped() }
    }
}

extension ShoppingListOptionView {
    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
        }

        func backButtonTapped() {
            navigator.goBack()
        }

        func selectItemsTapped() {
            navigator.toCheckList()
        }

        func makePhoneCallTapped() {
            navigator.toPhoneCall()
        }
    }

    static func createScreen(viewModel: ShoppingListOptionView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: ShoppingListOptionView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}

#if DEBUG
    struct ShoppingListOptionView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = ShoppingListOptionView.ViewModel(navigator: PreviewNavigator())
            return Group {
                ShoppingListOptionView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.locale, .init(identifier: "de"))

                ShoppingListOptionView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                ShoppingListOptionView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
