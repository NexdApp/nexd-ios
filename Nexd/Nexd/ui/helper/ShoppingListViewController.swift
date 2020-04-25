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

        let backButtonTitle = Driver.just(R.string.localizable.back_button_title().asBackButtonText())

        var backButtonTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.goBack()
            }
        }

        init(navigator: ScreenNavigating, helpList: HelpList) {
            self.helpList = helpList
            self.navigator = navigator
        }
    }

    private let scrollView = UIScrollView()
    private let shoppingListHeadingLabel = UILabel()
    private let backButton = BackButton.make()
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

        scrollView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(13)
            make.right.equalTo(view).offset(-12)
            make.top.equalTo(view).offset(26)
            make.height.equalTo(132)
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

        let groupedArticles = Dictionary(grouping: articles, by: { $0.articleId })

        for (_, articleList) in groupedArticles {
            guard let name = articleList.first?.article?.name else { continue }
            let itemView = ShoppingListItemView()
            itemView.title.attributedText = "\(name)".asListItemTitle()

            let count = articleList.reduce(0) { count, article -> Int64 in
                return count + (article.articleCount ?? 0)
            }

            itemView.amount.attributedText = "\(count)x".asListItemDetails()

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
            viewModel.backButtonTitle.drive(backButton.rx.attributedTitle(for: .normal)),
            backButton.rx.tap.bind(to: viewModel.backButtonTaps),
            checkoutButton.rx.controlEvent(.touchUpInside).bind(to: viewModel.checkoutButtonTaps)
        )
    }
}
