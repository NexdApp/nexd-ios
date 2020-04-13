//
//  ShoppingListViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class ShoppingListViewController: ViewController<ShoppingListViewController.ViewModel> {
    class ViewModel {
        private let navigator: ScreenNavigating
        let helpList: HelpList
        let shoppingListHeadingText = Driver.just(R.string.localizable.shopping_list_screen_title().asHeading())

        var checkoutButtonTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.toCheckoutScreen(helpList: viewModel.helpList)

            }
        }

        init(navigator: ScreenNavigating, helpList: HelpList) {
            self.helpList = helpList
            self.navigator = navigator
        }
    }

    private let scrollView = UIScrollView()
    private let shoppingListHeadingLabel = UILabel()
    private let stackView = UIStackView()
    private var checkoutButton = SubMenuButton.make(title: R.string.localizable.shopping_list_button_title_checkout())

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.color.nexdGreen()

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(shoppingListHeadingLabel)
        shoppingListHeadingLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().inset(104)
            make.left.right.equalToSuperview().inset(24)
        }

        scrollView.addSubview(stackView)
        stackView.asCard()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.snp.makeConstraints { make -> Void in
            make.top.equalTo(shoppingListHeadingLabel.snp.bottom).offset(8)
            make.left.right.equalTo(view).inset(12)
        }

        scrollView.addSubview(checkoutButton)
        checkoutButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(56)
        }

        guard let viewModel = viewModel else { return }
        let articles = viewModel.helpList.helpRequests.flatMap { helpRequest -> [HelpRequestArticle] in
            helpRequest.articles ?? []
        }
        for article in articles {
            guard let name = article.article?.name else { continue }
            let itemView = ShoppingListItemView()
            itemView.title.attributedText = "\(name)".asListItemTitle()

            if let count = article.articleCount {
                itemView.amount.attributedText = "\(count)x".asListItemDetails()
            }

            stackView.addArrangedSubview(itemView)

            itemView.snp.makeConstraints { make in
                make.left.equalTo(view).inset(13)
                make.height.equalTo(52)
            }
        }
    }

    override func bind(viewModel: ShoppingListViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.shoppingListHeadingText.drive(shoppingListHeadingLabel.rx.attributedText),
            checkoutButton.rx.controlEvent(.touchUpInside).bind(to: viewModel.checkoutButtonTaps)
        )
    }
}
