//
//  ShoppingListViewController.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift
import SnapKit
import SwaggerClient
import UIKit

class ShoppingListViewController: UIViewController {
    enum Style {
        static let headerHeight: CGFloat = 60
        static let rowHeight: CGFloat = 40
        static let buttonHeight: CGFloat = 52
    }

    struct Item {
        let isSelected: Bool
        let id: Int
        let title: String
    }

    struct Content {
        let items: [Item]
    }

    var shoppingList: ShoppingList?

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
            .map { lists -> ShoppingList? in
                var orderedLists = lists
                orderedLists.sort { first, second in first.createdAt < second.createdAt }
                return orderedLists.last
            }

        getShoppingList
            .flatMap { [weak self] list -> Single<[RequestArticle]> in
                guard let self = self, let list = list else {
                    return Single.just([])
                }
                return self.loadAllArticles(for: list)
            }
            .flatMap { articles in
                ArticlesService.shared.allArticles()
                    .map { allArticles -> [ShoppingListViewController.Item] in
                        articles.map { article in
                            let details = allArticles.first { $0._id == article.articleId }
                            return ShoppingListViewController.Item(isSelected: false, id: article.articleId, title: details?.name ?? "-")
                        }
                    }
            }
            .subscribe(onSuccess: { [weak self] items in
                log.debug("List loaded successfully... updating content (items: \(items.count))")
                self?.content = Content(items: items)
            }) { [weak self] error in
                log.error("Load failed: \(error)")
                self?.showError(title: R.string.localizable.shopping_list_overview_error_title(),
                                message: R.string.localizable.shopping_list_overview_error_loading_failed_message())
            }
            .disposed(by: disposeBag)
    }

    private func loadAllArticles(for shoppingList: ShoppingList) -> Single<[RequestArticle]> {
        return ShoppingListService.shared.fetchShoppingLists()
            .map {
                $0.filter { $0.status == "active" }.first
            }
            .flatMap { list -> Single<[RequestEntity]> in
                guard let list = list else {
                    return Single.just([])
                }

                return Single.zip(list.requests.map { RequestService.shared.fetchRequest(id: $0.requestId) })
            }
            .map { $0.flatMap { request in request.articles } }
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
        items[indexPath.row] = Item(isSelected: !item.isSelected, id: item.id, title: item.title)
        self.content = Content(items: items)
    }
}

extension ShoppingListViewController {
    @objc func checkoutButtonPressed(sender: UIButton!) {
        guard let content = content else { return }
//        ShoppingListService.shared.createShoppingList(requestIds: content.acceptedRequests.map { $0.id })
//            .subscribe(onCompleted: {
//                log.debug("Shoppping list created!")
//            }, onError: { error in
//                log.error("Failed to create shopping list: \(error)")
//            })
//            .disposed(by: disposeBag)
    }
}
