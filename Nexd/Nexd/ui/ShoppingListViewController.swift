//
//  ShoppingListViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import RxSwift
import SnapKit
import UIKit

class ShoppingListViewController: UIViewController {
    enum Style {
        static let headerHeight: CGFloat = 60
        static let rowHeight: CGFloat = 40
        static let buttonHeight: CGFloat = 52
    }

    struct Item {
        let isSelected: Bool
        let title: String
        let itemId: Int?
        let orderedBy: String?
    }

    struct Content {
        let items: [Item]
    }

    var shoppingList: HelpList?

    private let disposeBag = DisposeBag()

    private var gradient = GradientView()

    private var collectionView: UICollectionView?
    private var checkoutButton = UIButton()

    private var dataSource: DataSource<CheckableCell.Item>? {
        didSet {
            collectionView?.dataSource = dataSource
        }
    }

    private var content: Content? {
        didSet {
            dataSource = DataSource(reuseIdentifier: CheckableCell.reuseIdentifier,
                                    items: content?.items.map { CheckableCell.Item(isChecked: $0.isSelected, text: $0.title) } ?? []) { item, cell in
                if let cell = cell as? CheckableCell {
                    cell.bind(to: item)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: view.frame.size.width, height: Style.headerHeight)
        layout.itemSize = CGSize(width: view.frame.size.width, height: Style.rowHeight)

        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .clear
        list.delegate = self
        list.register(CheckableCell.self, forCellWithReuseIdentifier: CheckableCell.reuseIdentifier)

        title = R.string.localizable.shopping_list_screen_title()

        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        checkoutButton.addTarget(self, action: #selector(checkoutButtonPressed(sender:)), for: .touchUpInside)
        checkoutButton.style(text: R.string.localizable.shopping_list_button_title_checkout())
        view.addSubview(checkoutButton)
        checkoutButton.snp.makeConstraints { make in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.height.equalTo(Style.buttonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }

        view.addSubview(list)
        list.snp.makeConstraints { make -> Void in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(checkoutButton.snp.top).offset(8)
        }

        collectionView = list
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadContent()
    }

    private func loadContent() {
        let getShoppingList = shoppingList != nil ?
            Single.just(shoppingList) :
            ShoppingListService.shared.fetchShoppingLists()
            .map { lists in
                var activeList = lists.filter { $0.status == .active }
                activeList.sort { first, second in first.createdAt < second.createdAt }
                return activeList.first
            }

        getShoppingList
            .flatMap { [weak self] list -> Single<[HelpRequest]> in
                guard let self = self, let list = list else {
                    return Single.just([])
                }
                return self.loadAllRequests(for: list)
            }
            .flatMap { requests in
                ArticlesService.shared.allArticles()
                    .map { allArticles -> [Item] in
                        requests.flatMap { request -> [Item] in
                            guard let articles = request.articles else { return [] }

                            return articles.map { article -> Item in
                                 let details = allArticles.first { $0.id == article.articleId }

                                return Item(isSelected: false,
                                            title: details?.name ?? "-",
                                            itemId: article.articleId,
                                            orderedBy: request.requesterId)
                            }
                        }
                    }
            }
            .subscribe(onSuccess: { [weak self] items in
                log.debug("List loaded successfully... updating content (items: \(items.count))")
                self?.content = Content(items: items)
            }, onError: { [weak self] error in
                log.error("Load failed: \(error)")
                self?.showError(title: R.string.localizable.shopping_list_overview_error_title(),
                                message: R.string.localizable.shopping_list_overview_error_loading_failed_message())
            })
            .disposed(by: disposeBag)
    }

    private func loadAllRequests(for shoppingList: HelpList) -> Single<[HelpRequest]> {
        return Single.zip(shoppingList.helpRequests
            .compactMap { $0.id }
            .map { RequestService.shared.fetchRequest(requestId: $0) })
    }
}

extension ShoppingListViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // nothing yet
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let content = self.content else { return }

        var items = content.items
        let item = items[indexPath.row]
        items[indexPath.row] = Item(isSelected: !item.isSelected, title: item.title, itemId: item.itemId, orderedBy: item.orderedBy)
        self.content = Content(items: items)
    }
}

extension ShoppingListViewController {
    @objc func checkoutButtonPressed(sender: UIButton!) {
        guard let content = content else { return }
        let checkoutVC = CheckoutViewController()

        let allUserIds = Array(Set(content.items.map { $0.orderedBy }))
        let checkoutItems = allUserIds.map { userId -> CheckoutViewController.UserRequest in
            let items = content.items.filter { $0.orderedBy == userId }.map { CheckoutViewController.Item.from(item: $0) }
            return CheckoutViewController.UserRequest(userId: userId, items: items)
        }
        checkoutVC.content = CheckoutViewController.Content(requests: checkoutItems)

        navigationController?.pushViewController(checkoutVC, animated: true)
//        ShoppingListService.shared.createShoppingList(requestIds: content.acceptedRequests.map { $0.id })
//            .subscribe(onCompleted: {
//                log.debug("Shoppping list created!")
//            }, onError: { error in
//                log.error("Failed to create shopping list: \(error)")
//            })
//            .disposed(by: disposeBag)
    }
}
