////
////  ViewController.swift
////  Nexd
////
////  Created by Tobias Schröpf on 21.03.20.
////  Copyright © 2020 Tobias Schröpf. All rights reserved.
////
//
//import NexdClient
//import RxCocoa
//import RxSwift
//import SnapKit
//import UIKit
//
//class HelperRequestOverviewViewController: ViewController<HelperRequestOverviewViewController.ViewModel> {
//    class ViewModel {
//        private let navigator: ScreenNavigating
//        private let userService: UserService
//        private let helpRequestsService: HelpRequestsService
//        private let helpListsService: HelpListsService
//
//        private lazy var myZipCode = userService.findMe()
//            .map { $0.zipCode }
//
//        private let zipCodeChanges = PublishRelay<String?>()
//        private lazy var zipCode = myZipCode.asObservable().concat(zipCodeChanges.asObservable())
//            .share(replay: 1)
//
//        func currentItemsListButtonTaps() -> Completable {
////            let navigator = self.navigator
////            return helpList.take(1).flatMap { helpList -> Completable in
////                Completable.from {
////                    navigator.toCurrentItemsList(helpList: helpList)
////                }
////            }
////            .asCompletable()
//
//            Completable.empty()
//        }
//
//        let backButtonTitle = Driver.just(R.string.localizable.back_button_title().asBackButtonText())
//
//        var backButtonTaps: Binder<Void> {
//            Binder(self) { viewModel, _ in
//                viewModel.navigator.goBack()
//            }
//        }
//
//        let acceptedRequestsHeadingText = Driver.just(R.string.localizable.helper_request_overview_heading_accepted_section().asHeading())
//
//        let openRequestsFilterButtonTitle = Driver.just(R.string.localizable.helper_request_overview_heading_available_section().asHeading())
//        var openRequestsFilterButtonDetails: Driver<NSAttributedString?> {
//            return zipCode
//                .map { zipCode -> String in
//                    guard let zipCode = zipCode else { return R.string.localizable.helper_request_overview_filter_inactive() }
//
//                    return R.string.localizable.helper_request_overview_filter_selected_zip(zipCode)
//                }
//                .map { zipCode -> NSAttributedString in zipCode.asTitle() }
//                .asDriver(onErrorJustReturn: nil)
//        }
//
//        func openRequestsFilterButtonTaps() -> Completable {
//            return Completable.empty()
////            let navigator = self.navigator
////            return zipCode
////                .take(1)
////                .asSingle()
////                .flatMap { zipCode in navigator.changingHelperRequestFilterSettings(zipCode: zipCode) }
////                .flatMapCompletable { result -> Completable in
////                    Completable.from { [weak self] in
////                        self?.zipCodeChanges.accept(result?.zipCode)
////                    }
////                }
//        }
//
////        private let helpListUpdates = PublishRelay<HelpList>()
////        private lazy var helpList = helpListsService
////            .fetchShoppingLists()
////            .flatMap({ [weak self] existingLists -> Single<HelpList> in
////                if let existingList = existingLists.filter({ $0.status == .active }).first {
////                    return Single.just(existingList)
////                }
////
////                guard let self = self else { return Single.never() }
////
////                return self.helpListsService.createShoppingList(requestIds: [])
////            })
////            .asObservable()
////            .concat(helpListUpdates)
////            .share(replay: 1)
//
//        var acceptedRequests: Observable<[AcceptedRequestCell.Item]> {
//            helpList
//                .map { helpList -> [AcceptedRequestCell.Item] in
//                    helpList.helpRequests.map { helpRequest -> AcceptedRequestCell.Item in
//                        AcceptedRequestCell.Item(title: helpRequest.displayName)
//                    }
//                }
//                .asObservable()
//        }
//
//        func acceptedRequestSelected(indexPath: IndexPath) -> Completable {
//            return helpList
//                .take(1)
//                .flatMap { [weak self] helpList -> Completable in
//                    guard let self = self else { return Completable.empty() }
//                    return self.navigator.removingHelperRequest(request: helpList.helpRequests[indexPath.row], to: helpList, units: nil)
//                        .flatMapCompletable { [weak self] updatedHelpList in
//                            Completable.from {
//                                self?.helpListUpdates.accept(updatedHelpList)
//                                self?.openHelpRequestUpdateTrigger.accept(())
//                            }
//                        }
//                }
//                .ignoreElements()
//        }
//
//        private let openHelpRequestUpdateTrigger = PublishRelay<Void>()
//        private lazy var openHelpRequests: Observable<[HelpRequest]> = {
//            Observable.combineLatest(openHelpRequestUpdateTrigger.startWith(()),
//                                     zipCode)
//                .flatMapLatest { [weak self] _, zipCode -> Single<[HelpRequest]> in
//                    guard let self = self else { return Single.never() }
//
//                    guard let zipCode = zipCode else {
//                        return self.helpRequestsService.openRequests(userId: "me", excludeUserId: true, status: [.pending])
//                    }
//
//                    return self.helpRequestsService.openRequests(userId: "me", excludeUserId: true, zipCode: [zipCode], status: [.pending])
//                }
//                .share(replay: 1)
//        }()
//
//        var openRequests: Observable<[OpenReqeustsCell.Item]> {
//            return openHelpRequests
//                .map { requests in
//                    requests
//                        .map { request in
//                            let title = request.displayName
//                            let duration = request.createdAt?.difference()
//                            let type = request.callSid == nil ? R.string.localizable.helper_request_overview_item_type_list()
//                                : R.string.localizable.helper_request_overview_item_type_recording()
//                            let details = R.string.localizable.helper_request_overview_open_request_item_details_format_ios(duration ?? "???", type)
//                            return OpenReqeustsCell.Item(title: title, details: details)
//                        }
//                }
//                .asObservable()
//        }
//
//        func openRequestSelected(indexPath: IndexPath) -> Completable {
//            return openHelpRequests
//                .take(1)
//                .map { requests -> HelpRequest in requests[indexPath.row] }
//                .withLatestFrom(helpList) { ($0, $1) }
//                .flatMap { [weak self] helpRequest, helpList -> Completable in
//                    guard let self = self else { return Completable.empty() }
//                    return self.navigator.addingHelperRequest(request: helpRequest, to: helpList, units: nil)
//                        .flatMapCompletable { [weak self] updatedHelpList in
//                            Completable.from {
//                                self?.helpListUpdates.accept(updatedHelpList)
//                                self?.openHelpRequestUpdateTrigger.accept(())
//                            }
//                        }
//                }
//                .ignoreElements()
//        }
//
//        init(navigator: ScreenNavigating, userService: UserService, helpRequestsService: HelpRequestsService, helpListsService: HelpListsService) {
//            self.navigator = navigator
//            self.userService = userService
//            self.helpRequestsService = helpRequestsService
//            self.helpListsService = helpListsService
//        }
//    }
//
//    private let currentItemsListButton = SubMenuButton.make(title: R.string.localizable.helper_request_overview_button_title_current_items_list())
//    private let acceptedRequestsHeadingLabel = UILabel()
//    private var acceptedRequestsCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//
//        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        list.backgroundColor = .clear
//        list.registerCell(class: AcceptedRequestCell.self)
//
//        return list
//    }()
//
//    private let openRequestsFilterButton = FilterButton()
//    private var openRequestsCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//
//        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        list.backgroundColor = .clear
//        list.registerCell(class: OpenReqeustsCell.self)
//        return list
//    }()
//
//    private let backButton = BackButton.make()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        title = R.string.localizable.helper_request_overview_screen_title()
////        view.backgroundColor = R.color.nexdGreen()
//
////        view.addSubview(backButton)
////        backButton.snp.makeConstraints { make in
////            make.left.equalTo(view).offset(17)
////            make.right.equalTo(view).offset(-12)
////            make.top.equalTo(view).offset(26)
////            make.height.equalTo(132)
////        }
//
////        view.addSubview(currentItemsListButton)
////        currentItemsListButton.snp.makeConstraints { make in
////            make.top.equalToSuperview().offset(100)
////            make.left.right.equalTo(view).inset(19)
////            make.height.equalTo(74)
////        }
//
////        view.addSubview(acceptedRequestsHeadingLabel)
////        acceptedRequestsHeadingLabel.snp.makeConstraints { make in
////            make.top.equalTo(currentItemsListButton.snp.bottom).offset(11)
////            make.left.right.equalToSuperview().inset(19)
////        }
//
//        view.addSubview(acceptedRequestsCollectionView)
//        acceptedRequestsCollectionView.snp.makeConstraints { make -> Void in
//            make.left.right.equalToSuperview().inset(12)
//            make.top.equalTo(acceptedRequestsHeadingLabel.snp.bottom)
//            make.height.equalTo(153)
//        }
//
//        view.addSubview(openRequestsFilterButton)
//        openRequestsFilterButton.snp.makeConstraints { make in
//            make.top.equalTo(acceptedRequestsCollectionView.snp.bottom).offset(11)
//            make.left.right.equalToSuperview().inset(19)
//        }
//
//        view.addSubview(openRequestsCollectionView)
//        openRequestsCollectionView.snp.makeConstraints { make -> Void in
//            make.left.right.equalToSuperview().inset(12)
//            make.top.equalTo(openRequestsFilterButton.snp.bottom)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
//        }
//    }
//
//    override func bind(viewModel: HelperRequestOverviewViewController.ViewModel, disposeBag: DisposeBag) {
//        disposeBag.insert(
//            currentItemsListButton.rx.controlEvent(.touchUpInside).flatMap(viewModel.currentItemsListButtonTaps).subscribe(),
//            viewModel.acceptedRequestsHeadingText.drive(acceptedRequestsHeadingLabel.rx.attributedText),
//            viewModel.backButtonTitle.drive(backButton.rx.attributedTitle(for: .normal)),
//            viewModel.openRequestsFilterButtonTitle.drive(openRequestsFilterButton.titleLabel.rx.attributedText),
//            viewModel.openRequestsFilterButtonDetails.drive(openRequestsFilterButton.detailsLabel.rx.attributedText),
//            openRequestsFilterButton.rx.controlEvent(.touchUpInside).flatMapLatest(viewModel.openRequestsFilterButtonTaps).subscribe(),
//
//            acceptedRequestsCollectionView.rx.itemSelected.flatMapLatest(viewModel.acceptedRequestSelected(indexPath:)).subscribe(),
//            backButton.rx.tap.bind(to: viewModel.backButtonTaps),
//            acceptedRequestsCollectionView.rx.setDelegate(self),
//
//            openRequestsCollectionView.rx.itemSelected.flatMap(viewModel.openRequestSelected(indexPath:)).subscribe(),
//            openRequestsCollectionView.rx.setDelegate(self)
//        )
//
//        viewModel.acceptedRequests
//            .bind(to: acceptedRequestsCollectionView.rx.items(class: AcceptedRequestCell.self)) { _, item, cell in
//                cell.bind(to: item)
//            }
//            .disposed(by: disposeBag)
//
//        viewModel.openRequests
//            .bind(to: openRequestsCollectionView.rx.items(class: OpenReqeustsCell.self)) { _, item, cell in
//                cell.bind(to: item)
//            }
//            .disposed(by: disposeBag)
//    }
//}
//
//extension HelperRequestOverviewViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: collectionView.frame.size.width, height: 67)
//    }
//}
