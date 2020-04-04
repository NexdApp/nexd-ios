//
//  ViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import RxSwift
import SnapKit
import UIKit

class HelperRequestOverviewViewController: UIViewController {
    enum Style {
        static let headerHeight: CGFloat = 60
        static let rowHeight: CGFloat = 40
        static let buttonHeight: CGFloat = 52
    }

    struct Request {
        let requestId: Int
        let title: String
    }

    struct Content {
        let acceptedRequests: [Request]
        let availableRequests: [Request]
    }

    private let disposeBag = DisposeBag()

    private var gradient = GradientView()
    private var collectionView: UICollectionView?
    private var startButton = UIButton()

    private var dataSource: DefaultSectionedDataSource<DefaultCellItem>? {
        didSet {
            collectionView?.dataSource = dataSource
        }
    }

    private var content: Content? {
        didSet {
            var sections = [DefaultSectionedDataSource<DefaultCellItem>.Section]()
            if let content = content {
                let acceptedItems = content.acceptedRequests.map { DefaultCellItem(icon: R.image.baseline_shopping_basket_black_48pt(), text: $0.title) }
                let acceptedRequestsSection = DefaultSectionedDataSource<DefaultCellItem>.Section(reuseIdentifier: DefaultCell.reuseIdentifier,
                                                                                                  title: R.string.localizable.helper_request_overview_heading_accepted_section(),
                                                                                                  items: acceptedItems)

                let availableItems = content.availableRequests.map { DefaultCellItem(icon: R.image.baseline_shopping_basket_black_48pt(), text: $0.title) }
                let availableRequestsSection = DefaultSectionedDataSource<DefaultCellItem>.Section(reuseIdentifier: DefaultCell.reuseIdentifier,
                                                                                                   title: R.string.localizable.helper_request_overview_heading_available_section(),
                                                                                                   items: availableItems)

                sections.append(acceptedRequestsSection)
                sections.append(availableRequestsSection)
            }

            dataSource = DefaultSectionedDataSource(sections: sections, cellBinder: { item, cell in
                if let cell = cell as? DefaultCell {
                    cell.bind(to: item)
                }
            })
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
        list.register(DefaultCell.self, forCellWithReuseIdentifier: DefaultCell.reuseIdentifier)
        list.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)

        title = R.string.localizable.helper_request_overview_screen_title()

        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        startButton.addTarget(self, action: #selector(startButtonPressed(sender:)), for: .touchUpInside)
        startButton.style(text: R.string.localizable.helper_request_overview_button_title_start())
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.height.equalTo(Style.buttonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }

        view.addSubview(list)
        list.snp.makeConstraints { make -> Void in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).offset(8)
        }

        collectionView = list
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        RequestService.shared.openRequests()
            .flatMap { requests -> Single<[Request]> in
                Single.zip(requests
                    .filter { $0.status == .pending }
                    .compactMap { request in
                        guard let requesterId = request.requesterId, let requestId = request.id else { return nil }
                        return UserService.shared.fetchUserInfo(userId: requesterId)
                            .map { Request(requestId: requestId, title: "\($0.lastName) (\(request.articles?.count ?? 0))") } })
            }
            .subscribe(onSuccess: { [weak self] openRequests in
                log.debug("Open requests: \(openRequests)")

                // Status values:
                // NEW = 'new',
                // ONGOING = 'ongoing',
                // COMPLETED = 'completed',
                let content = Content(acceptedRequests: [], availableRequests: openRequests)

                self?.content = content
            }, onError: { error in
                log.error("Request failed: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

extension HelperRequestOverviewViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // nothing yet
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let content = self.content else {
            return
        }

        let addRequest = indexPath.section == 1

        var acceptedRequests = content.acceptedRequests
        var openRequests = content.availableRequests

        if addRequest {
            let request = openRequests.remove(at: indexPath.row)
            acceptedRequests.append(request)
        } else {
            let request = acceptedRequests.remove(at: indexPath.row)
            openRequests.append(request)
        }

        self.content = Content(acceptedRequests: acceptedRequests, availableRequests: openRequests)
    }
}

extension HelperRequestOverviewViewController {
    @objc func startButtonPressed(sender: UIButton!) {
        guard let content = content else { return }
        ShoppingListService.shared.createShoppingList(requestIds: content.acceptedRequests.map { $0.requestId })
            .subscribe(onSuccess: { [weak self] shoppingList in
                log.debug("Shoppping list created: \(shoppingList)")
                let shoppingListVC = ShoppingListViewController()
                shoppingListVC.shoppingList = shoppingList
                self?.navigationController?.pushViewController(shoppingListVC, animated: true)
            }, onError: { [weak self] error in
                log.error("Failed to create shopping list: \(error)")
                self?.showError(title: R.string.localizable.helper_request_overview_error_title(),
                                message: R.string.localizable.helper_request_overview_error_message())
            })
            .disposed(by: disposeBag)
    }
}
