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
    class ViewModel {
        private let navigator: ScreenNavigating
        private let helpList: HelpList

        let tileLabelText = Driver.just(R.string.localizable.checkout_screen_title().asHeading())
        init(navigator: ScreenNavigating, helpList: HelpList) {
            self.navigator = navigator
            self.helpList = helpList
        }
    }

    struct Item {
        let isSelected: Bool
        let title: String
        let itemId: Int64?

//        static func from(item: ShoppingListViewController.Item) -> Item {
//            return Item(isSelected: item.isSelected, title: item.title, itemId: item.itemId)
//        }
    }

    struct UserRequest {
        let user: User
        let items: [Item]
    }

    struct Content {
        let requests: [UserRequest]
    }

//    private var collectionView: UICollectionView? {
//        didSet {
//            collectionView?.dataSource = dataSource
//        }
//    }

//    private var dataSource: DefaultSectionedDataSource<CheckableCell.Item>? {
//        didSet {
//            collectionView?.dataSource = dataSource
//        }
//    }
//
//    var content: Content? {
//        didSet {
//            let sections = content?.requests.map { request -> DefaultSectionedDataSource<CheckableCell.Item>.Section in
//                let items = request.items.map { CheckableCell.Item(isChecked: $0.isSelected, text: $0.title) }
//                return DefaultSectionedDataSource<CheckableCell.Item>.Section(reuseIdentifier: CheckableCell.reuseIdentifier,
//                                                                              title: "\(request.user.firstName) \(request.user.lastName)",
//                                                                              items: items)
//            }
//
//            dataSource = DefaultSectionedDataSource(sections: sections ?? [], cellBinder: { item, cell in
//                if let cell = cell as? CheckableCell {
//                    cell.bind(to: item)
//                }
//            })
//        }
//    }

//    private var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//
//        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        list.backgroundColor = .clear
//        list.registerCell(class: AcceptedRequestCell.self)
//
//        return list
//    }()

    private let list = UIHostingController(rootView: CheckoutListView())

    private let titleLabel = UILabel()
    private let completeButton = SubMenuButton.make(title: R.string.localizable.checkout_button_title_complete())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.nexdGreen()

        view.addSubview(titleLabel)

        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

        addChild(list)
//        list.view.frame = view.frame
        view.addSubview(list.view)
        list.didMove(toParent: self)
        list.view.backgroundColor = .clear
//        view.addSubview(collectionView.view)

        view.addSubview(completeButton)

        titleLabel.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().inset(104)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(42)
        }

        list.view.snp.makeConstraints { make -> Void in
            make.left.right.equalToSuperview().inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(completeButton.snp.top).offset(-8)
        }

        completeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.height.equalTo(42)
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    override func bind(viewModel: CheckoutViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.tileLabelText.drive(titleLabel.rx.attributedText)
        )
    }
}

extension CheckoutViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // nothing yet
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
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
