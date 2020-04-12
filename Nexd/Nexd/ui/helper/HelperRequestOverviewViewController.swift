//
//  ViewController.swift
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

class HelperRequestOverviewViewController: ViewController<HelperRequestOverviewViewController.ViewModel> {
    class ViewModel {
        private let navigator: ScreenNavigating

        let acceptedRequestsHeadingText = Driver.just(R.string.localizable.helper_request_overview_heading_accepted_section().asHeading())
        let openRequestsHeadingText = Driver.just(R.string.localizable.helper_request_overview_heading_available_section().asHeading())

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
        }
    }

    enum Style {
        static let headerHeight: CGFloat = 60
        static let rowHeight: CGFloat = 40
        static let buttonHeight: CGFloat = 52
    }

    struct Request {
        let requestId: Int64
        let title: String
    }

    struct Content {
        let acceptedRequests: [Request]
        let availableRequests: [Request]
    }

    private let disposeBag = DisposeBag()

    private let currentItemsListButton = SubMenuButton.make(title: R.string.localizable.helper_request_overview_button_title_current_items_list())
    private let acceptedRequestsHeadingLabel = UILabel()
    private var acceptedRequestsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .clear
        list.registerCell(class: DefaultCell.self)

        return list
    }()

    private let openRequestsHeadingLabel = UILabel()
    private var openRequestsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .clear
        list.register(DefaultCell.self, forCellWithReuseIdentifier: DefaultCell.reuseIdentifier)
        list.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        return list
    }()

    private var dataSource: DefaultSectionedDataSource<DefaultCell.Item>? {
        didSet {
            acceptedRequestsCollectionView.dataSource = dataSource
            openRequestsCollectionView.dataSource = dataSource
        }
    }

    private var content: Content? {
        didSet {
            var sections = [DefaultSectionedDataSource<DefaultCell.Item>.Section]()
            if let content = content {
                let acceptedItems = content.acceptedRequests.map { DefaultCell.Item(icon: R.image.baseline_shopping_basket_black_48pt(), text: $0.title) }
                let acceptedRequestsSection = DefaultSectionedDataSource<DefaultCell.Item>.Section(reuseIdentifier: DefaultCell.reuseIdentifier,
                                                                                                   title: "FIXME",
                                                                                                   items: acceptedItems)

                let availableItems = content.availableRequests.map { DefaultCell.Item(icon: R.image.baseline_shopping_basket_black_48pt(), text: $0.title) }
                let availableRequestsSection = DefaultSectionedDataSource<DefaultCell.Item>.Section(reuseIdentifier: DefaultCell.reuseIdentifier,
                                                                                                    title: "FIXME",
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

        title = R.string.localizable.helper_request_overview_screen_title()
        view.backgroundColor = R.color.nexdGreen()

        view.addSubview(currentItemsListButton)
        currentItemsListButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalTo(view).inset(19)
            make.height.equalTo(74)
        }

        view.addSubview(acceptedRequestsHeadingLabel)
        acceptedRequestsHeadingLabel.snp.makeConstraints { make in
            make.top.equalTo(currentItemsListButton.snp.bottom).offset(11)
            make.left.right.equalToSuperview().inset(19)
        }

        view.addSubview(acceptedRequestsCollectionView)
        acceptedRequestsCollectionView.snp.makeConstraints { make -> Void in
            make.left.right.equalToSuperview().inset(12)
            make.top.equalTo(acceptedRequestsHeadingLabel.snp.bottom)
            make.height.equalTo(174)
        }

        view.addSubview(openRequestsHeadingLabel)
        openRequestsHeadingLabel.snp.makeConstraints { make in
            make.top.equalTo(acceptedRequestsCollectionView.snp.bottom).offset(11)
            make.left.right.equalToSuperview().inset(19)
        }

        view.addSubview(openRequestsCollectionView)
        openRequestsCollectionView.snp.makeConstraints { make -> Void in
            make.left.right.equalToSuperview().inset(12)
            make.top.equalTo(openRequestsHeadingLabel.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
        }

//        startButton.addTarget(self, action: #selector(startButtonPressed(sender:)), for: .touchUpInside)
//        startButton.style(text: R.string.localizable.helper_request_overview_button_title_start())
//        view.addSubview(startButton)
//        startButton.snp.makeConstraints { make in
//            make.leftMargin.equalTo(8)
//            make.rightMargin.equalTo(-8)
//            make.height.equalTo(Style.buttonHeight)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
//        }
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
                            .map { Request(requestId: requestId, title: "\($0.lastName) (\(request.articles?.count ?? 0))") }
                })
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

    override func bind(viewModel: HelperRequestOverviewViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.acceptedRequestsHeadingText.drive(acceptedRequestsHeadingLabel.rx.attributedText),
            viewModel.openRequestsHeadingText.drive(openRequestsHeadingLabel.rx.attributedText),

            acceptedRequestsCollectionView.rx.setDelegate(self),
            openRequestsCollectionView.rx.setDelegate(self)
        )
    }
}

extension HelperRequestOverviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 67)
    }
}

// extension HelperRequestOverviewViewController: UICollectionViewDelegate {
//    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        // nothing yet
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let content = self.content else {
//            return
//        }
//
//        let addRequest = indexPath.section == 1
//
//        var acceptedRequests = content.acceptedRequests
//        var openRequests = content.availableRequests
//
//        if addRequest {
//            let request = openRequests.remove(at: indexPath.row)
//            acceptedRequests.append(request)
//        } else {
//            let request = acceptedRequests.remove(at: indexPath.row)
//            openRequests.append(request)
//        }
//
//        self.content = Content(acceptedRequests: acceptedRequests, availableRequests: openRequests)
//    }
// }

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
