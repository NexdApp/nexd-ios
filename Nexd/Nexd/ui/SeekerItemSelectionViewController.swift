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
        let isSelected: Bool
        let itemId: Int64
        let title: String
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

        var confirmButtonTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
//                guard let content = content else { return }
//
//                let selectedItems = content.items
//                    .filter { $0.isSelected }
//                    .map { RequestService.RequestItem(itemId: $0.itemId, articleCount: 1) }
//                requestService.submitRequest(items: selectedItems).subscribe(onSuccess: { [weak self] request in
//                    log.debug("Succesful: \(request)")
//                    viewModel.navigator.showSuccess(title: R.string.localizable.seeker_success_title(), message: R.string.localizable.seeker_success_message()) {
//                        viewModel.navigator.goBack()
//                    }
//                }, onError: { [weak self] error in
//                    log.error("Error: \(error)")
//                    self?.showError(title: R.string.localizable.seeker_error_title(), message: R.string.localizable.seeker_error_message())
//                })
//                    .disposed(by: disposeBag)
            }
        }

        var items: Observable<[Item]> {
            articlesService.allArticles()
                .map { articles -> [Item] in
                    articles.map { Item(isSelected: false, itemId: $0.id, title: $0.name) }
                }
                .asObservable()
        }

        var itemSelected = PublishRelay<IndexPath>()

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
//        layout.itemSize = CGSize(width: view.frame.size.width, height: 66)

        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .clear
        list.register(ArticleSelectionCell.self, forCellWithReuseIdentifier: ArticleSelectionCell.reuseIdentifier)
        return list
    }()

    private var confirmButton = ConfirmButton()
    private var cancelButton = CancelButton()

//    private var dataSource: DataSource<CheckableCell.Item>? {
//        didSet {
//            collectionView?.dataSource = dataSource
//        }
//    }

//    private var content: Content? {
//        didSet {
//            dataSource = DataSource(reuseIdentifier: CheckableCell.reuseIdentifier,
//                                    items: content?.items.map { CheckableCell.Item(isChecked: $0.isSelected, text: $0.title) } ?? []) { item, cell in
//                if let cell = cell as? CheckableCell {
//                    cell.bind(to: item)
//                }
//            }
//        }
//    }

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
            cancelButton.rx.controlEvent(.touchUpInside).bind(to: viewModel.cancelButtonTaps)
        )

//        guard let collectionView = collectionView else { return }

        viewModel.items
            .bind(to: collectionView.rx.items(cellIdentifier: ArticleSelectionCell.reuseIdentifier, cellType: ArticleSelectionCell.self)) { _, item, cell in
                cell.bind(to: ArticleSelectionCell.Item(title: item.title, amount: "0"))
            }
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)

        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        loadArticles()
//    }

//    private func loadArticles() {
//        ArticlesService.shared.allArticles()
//            .subscribe(onSuccess: { [weak self] articles in
//                log.debug("Articles: \(articles)")
//                self?.content = Content(items: articles.map { Item(isSelected: false, itemId: $0.id, title: $0.name) })
//            }, onError: { error in
//                log.error("Error occurred: \(error)")
//            })
//            .disposed(by: disposeBag)
//    }
}

extension SeekerItemSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 66)
    }
}
