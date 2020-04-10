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
    enum Style {
        static let headerHeight: CGFloat = 60
        static let rowHeight: CGFloat = 40
        static let buttonHeight: CGFloat = 52
    }

    struct Item {
        let isSelected: Bool
        let itemId: Int64
        let title: String
    }

    struct Content {
        let items: [Item]
    }

    class ViewModel {
        let navigator: ScreenNavigating

        let titleText = Driver.just(R.string.localizable.seeker_item_selection_screen_title().asHeading())

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
        }
    }

    private let disposeBag = DisposeBag()

    private var titleText = UILabel()
    private var collectionView: UICollectionView?
    private var submitButton = UIButton()

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
        layout.itemSize = CGSize(width: view.frame.size.width, height: Style.rowHeight)

        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .clear
        list.delegate = self
        list.register(CheckableCell.self, forCellWithReuseIdentifier: CheckableCell.reuseIdentifier)
        list.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)

        view.backgroundColor = R.color.nexdGreen()

        view.addSubview(titleText)
        titleText.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(75)
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(35)
        }

        submitButton.addTarget(self, action: #selector(submitButtonPressed(sender:)), for: .touchUpInside)
        submitButton.style(text: R.string.localizable.seeker_submit_button_title())
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.height.equalTo(Style.buttonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }

        view.addSubview(list)
        list.snp.makeConstraints { make -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleText.snp.bottom).offset(20)
            make.bottom.equalTo(submitButton.snp.top).offset(8)
        }

        collectionView = list
    }

    override func bind(viewModel: SeekerItemSelectionViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.titleText.drive(titleText.rx.attributedText)
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadArticles()
    }

    private func loadArticles() {
        ArticlesService.shared.allArticles()
            .subscribe(onSuccess: { [weak self] articles in
                log.debug("Articles: \(articles)")
                self?.content = Content(items: articles.map { Item(isSelected: false, itemId: $0.id, title: $0.name) })
            }, onError: { error in
                log.error("Error occurred: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

extension SeekerItemSelectionViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // nothing yet
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let content = self.content else { return }

        var items = content.items
        let item = items[indexPath.row]
        items[indexPath.row] = Item(isSelected: !item.isSelected, itemId: item.itemId, title: item.title)
        self.content = Content(items: items)
    }
}

extension SeekerItemSelectionViewController {
    @objc func submitButtonPressed(sender: UIButton!) {
        guard let content = content else { return }

        let selectedItems = content.items.filter { $0.isSelected }.map { RequestService.RequestItem(itemId: $0.itemId, articleCount: 1) }
        RequestService.shared.submitRequest(items: selectedItems).subscribe(onSuccess: { [weak self] request in
            log.debug("Succesful: \(request)")
            self?.showSuccess(title: R.string.localizable.seeker_success_title(), message: R.string.localizable.seeker_success_message()) {
                self?.navigationController?.popViewController(animated: true)
            }
        }, onError: { [weak self] error in
            log.error("Error: \(error)")
            self?.showError(title: R.string.localizable.seeker_error_title(), message: R.string.localizable.seeker_error_message())
        })
            .disposed(by: disposeBag)
    }
}
