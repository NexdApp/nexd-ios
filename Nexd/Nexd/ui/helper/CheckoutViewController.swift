//
//  CheckoutViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import RxCocoa
import RxSwift
import SnapKit
import SwiftUI
import UIKit

class CheckoutViewController: ViewController<CheckoutViewController.ViewModel> {
    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating
        @Published var helpList: HelpList

        var requests: [Request] {
            helpList.helpRequests.map { helpRequest -> Request in
                Request(requestId: Int(helpRequest.id ?? 0), title: helpRequest.requester?.firstName ?? "-",
                        articles: helpRequest.articles?.compactMap {
                            guard let article = $0.article else { return nil}
                            return Item(itemId: article.id, name: article.name)
                } ?? [])
            }
        }

        let tileLabelText = Driver.just(R.string.localizable.checkout_screen_title().asHeading())
        init(navigator: ScreenNavigating, helpList: HelpList) {
            self.navigator = navigator
            self.helpList = helpList
        }

        var checkoutButtonTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.toDeliveryConfirmationScreen(helpList: viewModel.helpList)
            }
        }
    }

    struct Item {
        let itemId: Int64
        let name: String
    }

    struct Request {
        let requestId: Int
        let title: String
        let articles: [Item]
    }

    private let titleLabel = UILabel()

    // implemented in SwiftUI - just because I can!!
    private var list: UIHostingController<CheckoutListView>? {
        willSet(newList) {
            guard let list = list else { return }

            list.willMove(toParent: nil)
            list.view.removeFromSuperview()
            list.removeFromParent()
        }
        didSet {
            guard let list = list else { return }
            addChild(list)
            view.addSubview(list.view)
            list.didMove(toParent: self)
            list.view.backgroundColor = .clear

            list.view.snp.makeConstraints { make -> Void in
                make.left.right.equalToSuperview().inset(12)
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.bottom.equalTo(completeButton.snp.top).offset(-8)
            }
        }
    }

    private let completeButton = SubMenuButton.make(title: R.string.localizable.checkout_button_title_complete())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.nexdGreen()

        view.addSubview(titleLabel)
        view.addSubview(completeButton)

        titleLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().inset(104)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(42)
        }

        completeButton.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(56)
        }
    }

    override func bind(viewModel: CheckoutViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.tileLabelText.drive(titleLabel.rx.attributedText),
            completeButton.rx.controlEvent(.touchUpInside).bind(to: viewModel.checkoutButtonTaps)
        )

        list = UIHostingController(rootView: CheckoutListView(requests: viewModel.requests))
    }
}

extension CheckoutViewController {
    @objc func completeButtonPressed(sender: UIButton!) {
//        guard let content = content else { return }
//        ShoppingListService.shared.createShoppingList(requestIds: content.acceptedRequests.map { $0.id })
//            .subscribe(onSuccess: { [weak self] shoppingList in
//                log.debug("Shoppping list created: \(shoppingList)")
//                let shoppingListVC = ShoppingListViewController()
//                shoppingListVC.shoppingList = shoppingList
//                self?.navigationController?.pushViewController(shoppingListVC, animated: true)
//            }, onError: { [weak self] error in
//                log.error("Failed to create shopping list: \(error)")
//                self?.showError(title: R.string.localizable.helper_request_overview_error_title(),
//                                message: R.string.localizable.helper_request_overview_error_message())
//            })
//            .disposed(by: disposeBag)
    }
}
