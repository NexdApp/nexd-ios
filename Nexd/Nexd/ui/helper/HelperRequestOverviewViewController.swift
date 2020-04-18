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
        private let helpRequestsService: HelpRequestsService
        private let helpListsService: HelpListsService

        func currentItemsListButtonTaps() -> Completable {
            let navigator = self.navigator
            return helpList.take(1).flatMap { helpList -> Completable in
                Completable.from {
                    navigator.toCurrentItemsList(helpList: helpList)
                }
            }
            .asCompletable()
        }

        let acceptedRequestsHeadingText = Driver.just(R.string.localizable.helper_request_overview_heading_accepted_section().asHeading())
        let openRequestsHeadingText = Driver.just(R.string.localizable.helper_request_overview_heading_available_section().asHeading())

        private let helpListUpdates = PublishRelay<HelpList>()
        private lazy var helpList = helpListsService.createShoppingList(requestIds: [])
            .asObservable()
            .concat(helpListUpdates)
            .share(replay: 1)

        var acceptedRequests: Observable<[AcceptedRequestCell.Item]> {
            helpList
                .map { helpList -> [AcceptedRequestCell.Item] in
                    helpList.helpRequests.map { helpRequest -> AcceptedRequestCell.Item in
                        return AcceptedRequestCell.Item(title: helpRequest.displayName)
                    }
                }
                .asObservable()
        }

        var acceptedRequestSelected: Binder<IndexPath> {
            Binder(self) { _, indexPath in
                log.debug("Item selected: \(indexPath)")
            }
        }

        private let openHelpRequestUpdateTrigger = PublishRelay<Void>()
        private lazy var openHelpRequests: Observable<[HelpRequest]> = { helpRequestsService
            .openRequests(status: [.pending])
            .asObservable()
            .concat(openHelpRequestUpdateTrigger.flatMapLatest { [weak self] _ -> Single<[HelpRequest]> in
                guard let self = self else { return Single.never() }

                return self.helpRequestsService.openRequests(status: [.pending])
            })
            .share(replay: 1)
        }()

        var openRequests: Observable<[OpenReqeustsCell.Item]> {
            return openHelpRequests
                .map { requests in
                    requests
                        .map { request in
                            let title = request.displayName
                            let duration = request.createdAt?.difference()
                            let type = R.string.localizable.helper_request_overview_item_type_list()
                            let details = R.string.localizable.helper_request_overview_open_request_item_details_format_ios(duration ?? "???", type)
                            return OpenReqeustsCell.Item(title: title, details: details)
                        }
                }
                .asObservable()
        }

        func openRequestSelected(indexPath: IndexPath) -> Completable {
            let helpListsService = self.helpListsService
            return openHelpRequests
                .take(1)
                .map { requests -> HelpRequest in
                    requests[indexPath.row]
                }
                .withLatestFrom(helpList) { ($0, $1) }
                .flatMap { helpRequest, helpList -> Completable in
                    guard let requestId = helpRequest.id else { return Completable.empty() }
                    return helpListsService.addRequest(withId: requestId, to: helpList.id)
                        .flatMapCompletable { helpList -> Completable in
                            Completable.from { [weak self] in
                                self?.helpListUpdates.accept(helpList)
                                self?.openHelpRequestUpdateTrigger.accept(())
                            }
                        }
                    .catchError { error -> Completable in
                        log.error("Adding request failed!")
                        return Completable.empty()
                    }
                }
                .ignoreElements()
        }

        init(navigator: ScreenNavigating, helpRequestsService: HelpRequestsService, helpListsService: HelpListsService) {
            self.navigator = navigator
            self.helpRequestsService = helpRequestsService
            self.helpListsService = helpListsService
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
            currentItemsListButton.rx.controlEvent(.touchUpInside).flatMap {viewModel.currentItemsListButtonTaps() }.subscribe(),
            viewModel.acceptedRequestsHeadingText.drive(acceptedRequestsHeadingLabel.rx.attributedText),
            viewModel.openRequestsHeadingText.drive(openRequestsHeadingLabel.rx.attributedText),

            acceptedRequestsCollectionView.rx.itemSelected.bind(to: viewModel.acceptedRequestSelected),
            acceptedRequestsCollectionView.rx.setDelegate(self),

            openRequestsCollectionView.rx.itemSelected.flatMap(viewModel.openRequestSelected(indexPath:)).subscribe(),
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

