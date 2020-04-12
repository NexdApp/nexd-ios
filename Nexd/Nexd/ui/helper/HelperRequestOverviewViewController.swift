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
        private let requestService: RequestService

        let acceptedRequestsHeadingText = Driver.just(R.string.localizable.helper_request_overview_heading_accepted_section().asHeading())
        let openRequestsHeadingText = Driver.just(R.string.localizable.helper_request_overview_heading_available_section().asHeading())

        var acceptedRequests: Observable<[AcceptedRequestCell.Item]> {
            return requestService.openRequests()
                .map { requests in requests
                    .map { request in
                        let title = request.requester?.firstName ?? R.string.localizable.helper_request_overview_unknown_requester()
                        return AcceptedRequestCell.Item(title: title)
                    }
                }
                .asObservable()
        }

        var openRequests: Observable<[OpenReqeustsCell.Item]> {
            return requestService.openRequests()
                .map { requests in requests
                    .map { request in
                        let title = request.requester?.firstName ?? R.string.localizable.helper_request_overview_unknown_requester()
                        let duration = request.createdAt?.difference()
                        let type = R.string.localizable.helper_request_overview_item_type_list()
                        let details = R.string.localizable.helper_request_overview_open_request_item_details_format_ios(duration ?? "???", type)
                        return OpenReqeustsCell.Item(title: title, details: details)
                    }
                }
                .asObservable()
        }

        init(navigator: ScreenNavigating, requestService: RequestService) {
            self.navigator = navigator
            self.requestService = requestService
        }
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
        list.registerCell(class: AcceptedRequestCell.self)

        return list
    }()

    private let openRequestsHeadingLabel = UILabel()
    private var openRequestsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .clear
        list.registerCell(class: OpenReqeustsCell.self)
        return list
    }()

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
            make.height.equalTo(153)
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
    }

    override func bind(viewModel: HelperRequestOverviewViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.acceptedRequestsHeadingText.drive(acceptedRequestsHeadingLabel.rx.attributedText),
            viewModel.openRequestsHeadingText.drive(openRequestsHeadingLabel.rx.attributedText),

            acceptedRequestsCollectionView.rx.setDelegate(self),
            openRequestsCollectionView.rx.setDelegate(self)
        )

        viewModel.acceptedRequests
            .bind(to: acceptedRequestsCollectionView.rx.items(class: AcceptedRequestCell.self)) { _, item, cell in
                cell.bind(to: item)
            }
            .disposed(by: disposeBag)

        viewModel.openRequests
            .bind(to: openRequestsCollectionView.rx.items(class: OpenReqeustsCell.self)) { _, item, cell in
                cell.bind(to: item)
            }
            .disposed(by: disposeBag)
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
//
//extension HelperRequestOverviewViewController {
//    @objc func startButtonPressed(sender: UIButton!) {
//        guard let content = content else { return }
//        ShoppingListService.shared.createShoppingList(requestIds: content.acceptedRequests.map { $0.requestId })
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
//    }
//}
