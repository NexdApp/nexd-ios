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

// class ShoppingListOptionViewController: ViewController<ShoppingListOptionViewController.ViewModel> {
//    class ViewModel {
//        private let navigator: ScreenNavigating
//
//        let heading = Driver.just(R.string.localizable.seeker_type_screen_title().asHeading())
//        let selectItemsTitle = Driver.just(R.string.localizable.seeker_type_button_help_request().asDarkButtonText())
//
//        var selectItemTaps: Binder<Void> {
//            Binder(self) { viewModel, _ in
//                viewModel.navigator.toCheckList()
//            }
//        }
//
//        let backButtonTitle = Driver.just(R.string.localizable.back_button_title().asBackButtonText())
//
//        var backButtonTaps: Binder<Void> {
//            Binder(self) { viewModel, _ in
//                viewModel.navigator.goBack()
//            }
//        }
//
//        let makePhonecallTitle = Driver.just(R.string.localizable.seeker_type_button_phone_call().asDarkButtonText())
//
//        var makePhonecallTaps: Binder<Void> {
//            Binder(self) { viewModel, _ in
//                viewModel.navigator.toPhoneCall()
//            }
//        }
//
//        init(navigator: ScreenNavigating) {
//            self.navigator = navigator
//        }
//    }
//
//    private let scrollView = UIScrollView()
//    private let titleLabel = UILabel()
//    private let backButton = BackButton.make()
//
//    private let selectItemsButton = MenuButton.make(style: .dark)
//    private let makePhonecallButton = MenuButton.make(style: .dark)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = R.color.nexdGreen()
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { make in
//            make.left.bottom.right.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//        }
//
//        scrollView.addSubview(titleLabel)
//        titleLabel.numberOfLines = 0
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(100)
//            make.left.equalTo(view).offset(19)
//            make.right.equalTo(view).offset(-19)
//        }
//
//        scrollView.addSubview(backButton)
//        backButton.snp.makeConstraints { make in
//            make.left.equalTo(view).offset(12)
//            make.right.equalTo(view).offset(-12)
//            make.top.equalTo(view).offset(25)
//            make.height.equalTo(132)
//        }
//
//        scrollView.addSubview(selectItemsButton)
//        selectItemsButton.snp.makeConstraints { make in
//            make.left.equalTo(view).offset(12)
//            make.right.equalTo(view).offset(-12)
//            make.top.equalTo(titleLabel.snp.bottom).offset(25)
//            make.height.equalTo(132)
//        }
//
////        Make Phone Call Button will be reenabled as soon as the hotline is getting better
////        Check the issue: https://github.com/NexdApp/nexd-ios/issues/54
////        scrollView.addSubview(makePhonecallButton)
////        makePhonecallButton.snp.makeConstraints { make in
////            make.left.equalTo(view).offset(12)
////            make.right.equalTo(view).offset(-12)
////            make.top.equalTo(selectItemsButton.snp.bottom).offset(25)
////            make.height.equalTo(132)
////            make.bottom.equalToSuperview().offset(-25)
////        }
//    }
//
//    override func bind(viewModel: ShoppingListOptionViewController.ViewModel, disposeBag: DisposeBag) {
//        disposeBag.insert(
//            viewModel.heading.drive(titleLabel.rx.attributedText),
//            viewModel.backButtonTitle.drive(backButton.rx.attributedTitle(for: .normal)),
//            viewModel.selectItemsTitle.drive(selectItemsButton.rx.attributedTitle(for: .normal)),
//            viewModel.makePhonecallTitle.drive(makePhonecallButton.rx.attributedTitle(for: .normal)),
//
//            selectItemsButton.rx.tap.bind(to: viewModel.selectItemTaps),
//            backButton.rx.tap.bind(to: viewModel.backButtonTaps),
//            makePhonecallButton.rx.tap.bind(to: viewModel.makePhonecallTaps)
//        )
//    }
// }
