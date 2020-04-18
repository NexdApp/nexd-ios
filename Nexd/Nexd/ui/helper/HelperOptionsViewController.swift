//
//  HelperOptionsViewController.swift
//  nexd
//
//  Created by Tobias Schröpf on 11.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HelperOptionsViewController: ViewController<HelperOptionsViewController.ViewModel> {
    class ViewModel {
        private let navigator: ScreenNavigating

        let heading = Driver.just(R.string.localizable.helper_type_screen_title().asHeading())
        let transcribeCallTitle = Driver.just(R.string.localizable.helper_type_button_transcript().asDarkButtonText())

        var transcribeCallTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.toTranscribeInfoView()
            }
        }

        let goShoppingTitle = Driver.just(R.string.localizable.helper_type_button_shopping().asDarkButtonText())

        var goShoppingTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.toHelperOverview()
            }
        }

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
        }
    }

    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()

    private let transcribeCallButton = MenuButton.make(style: .dark)
    private let goShoppingButton = MenuButton.make(style: .dark)

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

        scrollView.addSubview(transcribeCallButton)
        transcribeCallButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(12)
            make.right.equalTo(view).offset(-12)
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.height.equalTo(132)
        }

        scrollView.addSubview(goShoppingButton)
        goShoppingButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(12)
            make.right.equalTo(view).offset(-12)
            make.top.equalTo(transcribeCallButton.snp.bottom).offset(25)
            make.height.equalTo(132)
            make.bottom.equalToSuperview().offset(-25)
        }
    }

    override func bind(viewModel: HelperOptionsViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.heading.drive(titleLabel.rx.attributedText),
            viewModel.transcribeCallTitle.drive(transcribeCallButton.rx.attributedTitle(for: .normal)),
            viewModel.goShoppingTitle.drive(goShoppingButton.rx.attributedTitle(for: .normal)),

            transcribeCallButton.rx.tap.bind(to: viewModel.transcribeCallTaps),
            goShoppingButton.rx.tap.bind(to: viewModel.goShoppingTaps)
        )
    }
}
