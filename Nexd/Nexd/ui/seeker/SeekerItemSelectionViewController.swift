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

    class ViewModel {
        private let navigator: ScreenNavigating
        private let articlesService: ArticlesService

        let titleText = Driver.just(R.string.localizable.seeker_item_selection_screen_title().asHeading())

        let backButtonTitle = Driver.just(R.string.localizable.back_button_title().asBackButtonText())

        var backButtonTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.goBack()
            }
        }

        var confirmButtonTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                guard let items = viewModel.userUpdates.value else { return }

                let requestItems = items
                    .filter { $0.amount > 0 }
                    .map { item in RequestConfirmationViewController.Item(itemId: item.itemId, title: item.title, amount: item.amount) }
                viewModel.navigator.toRequestConfirmation(items: requestItems)
            }
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

        init(navigator: ScreenNavigating, articlesService: ArticlesService) {
            self.navigator = navigator
            self.articlesService = articlesService
        }
    }

    private var titleText = UILabel()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .clear
        list.registerCell(class: ArticleSelectionCell.self)
        return list
    }()

    private var confirmButton = ConfirmButton()
    private let backButton = BackButton.make()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.nexdGreen()

        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(12)
            make.right.equalTo(view).offset(-12)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(22)
            make.height.equalTo(22)
        }

        view.addSubview(titleText)
        titleText.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(29)
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(35)
        }

        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.left.equalTo(34)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview().offset(34)
            make.right.equalToSuperview().offset(-36)
            make.top.equalTo(titleText.snp.bottom).offset(20)
            make.bottom.equalTo(confirmButton.snp.top).offset(-32)
        }
    }

    override func bind(viewModel: SeekerItemSelectionViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.titleText.drive(titleText.rx.attributedText),
            viewModel.backButtonTitle.drive(backButton.rx.attributedTitle(for: .normal)),

            backButton.rx.tap.bind(to: viewModel.backButtonTaps),
            confirmButton.rx.controlEvent(.touchUpInside).bind(to: viewModel.confirmButtonTaps)
        )

        viewModel.items
            .bind(to: collectionView.rx.items(class: ArticleSelectionCell.self)) { [weak self] _, item, cell in
                cell.bind(to: ArticleSelectionCell.Item(title: item.title,
                                                        amount: String(item.amount),
                                                        amountChanged: { amount in
                                                            self?.viewModel?.itemDidChangeAmount(item, amount: Int64(amount))
                }))
            }
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
