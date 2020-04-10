//
//  SeekerItemSelectinViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class SeekerItemSelectionViewController: ViewController<SeekerItemSelectionViewController.ViewModel> {
    struct Item {
        let itemId: Int64
        let title: String
        let amount: Int64
    }

    struct Content {
        let items: [Item]
    }

    class ViewModel {
        private let navigator: ScreenNavigating
        private let articlesService: ArticlesService
        private let requestService: RequestService

        let titleText = Driver.just(R.string.localizable.seeker_item_selection_screen_title().asHeading())

        var cancelButtonTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.goBack()
            }
        }

        var confirmButtonTaps: Completable {
            let requestService = self.requestService
            return userUpdates
                .take(1)
                .asSingle()
                .flatMapCompletable { items -> Completable in
                    guard let items = items else { return Completable.empty() }

                    let requestItems = items
                        .filter { $0.amount > 0 }
                        .map { item in RequestService.RequestItem(itemId: item.itemId, articleCount: item.amount) }

                    return requestService.submitRequest(items: requestItems)
                        .asCompletable()
                }
                .do(onError: { [weak self] error in
                    log.error("Error: \(error)")
                    self?.navigator.showError(title: R.string.localizable.seeker_error_title(), message: R.string.localizable.seeker_error_message(), handler: nil)
                }, onCompleted: { [weak self] in
                    log.debug("Succesful:")
                    self?.navigator.showSuccess(title: R.string.localizable.seeker_success_title(), message: R.string.localizable.seeker_success_message()) {
                        self?.navigator.goBack()
                    }
                })
        }

        private let userUpdates = BehaviorRelay<[Item]?>(value: nil)
        var items: Observable<[Item]> {
            let relay = userUpdates
            let initialLoad = articlesService.allArticles()
                .map { articles -> [Item] in
                    articles.map { Item(itemId: $0.id, title: $0.name, amount: 0) }
                }
                .flatMapCompletable { items -> Completable in Completable.from { relay.accept(items) } }

            return Observable.merge(initialLoad.asObservable().ofType(), userUpdates.compactMap { $0 }.asObservable())
        }

        var itemSelected = PublishRelay<IndexPath>()

        func itemDidChangeAmount(_ item: Item, amount: Int64) {
            log.debug("itemDidChangeAmount - item: \(item) - amount: \(amount)")
            guard let items = userUpdates.value else { return }

            let updatedItems = items
                .map { element -> Item in
                    guard element.itemId == item.itemId else { return element }
                    return Item(itemId: element.itemId, title: element.title, amount: amount)
                }

            userUpdates.accept(updatedItems)
        }

        init(navigator: ScreenNavigating, articlesService: ArticlesService, requestService: RequestService) {
            self.navigator = navigator
            self.articlesService = articlesService
            self.requestService = requestService
        }
    }

    private var titleText = UILabel()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .clear
        list.register(ArticleSelectionCell.self, forCellWithReuseIdentifier: ArticleSelectionCell.reuseIdentifier)
        return list
    }()

    private var confirmButton = ConfirmButton()
    private var cancelButton = CancelButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.nexdGreen()

        view.addSubview(titleText)
        titleText.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(75)
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(35)
        }

        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(34)
        }

        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.left.equalTo(34)
            make.top.equalTo(cancelButton.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview().offset(34)
            make.right.equalToSuperview().offset(-36)
            make.top.equalTo(titleText.snp.bottom).offset(20)
            make.bottom.equalTo(cancelButton.snp.top).offset(-32)
        }
    }

    override func bind(viewModel: SeekerItemSelectionViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.titleText.drive(titleText.rx.attributedText),
            cancelButton.rx.controlEvent(.touchUpInside).bind(to: viewModel.cancelButtonTaps),
            confirmButton.rx.controlEvent(.touchUpInside)
                .flatMap { _ -> Completable in viewModel.confirmButtonTaps }
                .subscribe()
        )

        viewModel.items
            .bind(to: collectionView.rx.items(cellIdentifier: ArticleSelectionCell.reuseIdentifier,
                                              cellType: ArticleSelectionCell.self)) { [weak self] _, item, cell in
                cell.bind(to: ArticleSelectionCell.Item(title: item.title,
                                                        amount: String(item.amount),
                                                        amountChanged: { amount in
                                                            self?.viewModel?.itemDidChangeAmount(item, amount: Int64(amount))
                }))
            }
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)

        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension SeekerItemSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 66)
    }
}

extension ObservableConvertibleType {
    func ofType<R>() -> RxSwift.Observable<R> {
        return of(type: R.self)
    }

    func of<R>(type: R.Type) -> RxSwift.Observable<R> {
        return Observable.create { observer in
            let subscription = self.asObservable().subscribe { event in
                switch event {
                case let .next(value):
                    if let typeValue = value as? R {
                        observer.on(.next(typeValue))
                    }

                case let .error(error):
                    observer.on(.error(error))

                case .completed:
                    observer.on(.completed)
                }
            }

            return subscription
        }
    }
}
