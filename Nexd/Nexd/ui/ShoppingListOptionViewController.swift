//
//  ShoppingListOptionViewController.swift
//  nexd
//
//  Created by Tobias Schröpf on 10.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ShoppingListOptionViewController: ViewController<ShoppingListOptionViewController.ViewModel> {
    class ViewModel {
        private let navigator: ScreenNavigating

        let heading = Driver.just(R.string.localizable.helper_type_screen_title().asHeading())
        let selectItemsTitle = Driver.just(R.string.localizable.seeker_type_button_help_request().asDarkButtonText())

        var selectItemTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.toCheckList()
            }
        }

        let makePhonecallTitle = Driver.just(R.string.localizable.seeker_type_button_phone_call().asDarkButtonText())

        var makePhonecallTaps: Binder<Void> {
            Binder(self) { _, _ in
                log.debug("NOT IMPLEMENTED YET!")
            }
        }

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
        }
    }

    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()

    private let selectItemsButton = MenuButton.make(style: .dark)
    private let makePhonecallButton = MenuButton.make(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.color.nexdGreen()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        scrollView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalTo(view).offset(19)
            make.right.equalTo(view).offset(-19)
            make.height.equalTo(84)
        }

        scrollView.addSubview(selectItemsButton)
        selectItemsButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(12)
            make.right.equalTo(view).offset(-12)
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.height.equalTo(132)
        }

        scrollView.addSubview(makePhonecallButton)
        makePhonecallButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(12)
            make.right.equalTo(view).offset(-12)
            make.top.equalTo(selectItemsButton.snp.bottom).offset(25)
            make.height.equalTo(132)
            make.bottom.equalToSuperview().offset(-25)
        }
    }

    override func bind(viewModel: ShoppingListOptionViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.heading.drive(titleLabel.rx.attributedText),
            viewModel.selectItemsTitle.drive(selectItemsButton.rx.attributedTitle(for: .normal)),
            viewModel.makePhonecallTitle.drive(makePhonecallButton.rx.attributedTitle(for: .normal)),

            selectItemsButton.rx.tap.bind(to: viewModel.selectItemTaps),
            makePhonecallButton.rx.tap.bind(to: viewModel.makePhonecallTaps)
        )
    }
}
