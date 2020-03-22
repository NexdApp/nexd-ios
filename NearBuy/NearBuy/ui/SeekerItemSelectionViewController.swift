//
//  SeekerItemSelectinViewController.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit

class SeekerItemSelectionViewController: UIViewController {
    enum Style {
        static let headerHeight: CGFloat = 60
        static let rowHeight: CGFloat = 40
    }

    struct Item {
        let isSelected: Bool
        let id: Int
        let title: String
    }

    struct Content {
        let items: [Item]
    }

    private let disposeBag = DisposeBag()

    private lazy var gradient = GradientView()
    private var collectionView: UICollectionView?
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

        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: Style.rowHeight)

        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .white
        list.delegate = self
        list.register(CheckableCell.self, forCellWithReuseIdentifier: CheckableCell.reuseIdentifier)
        list.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)

        view.backgroundColor = .white
        title = R.string.localizable.seeker_item_selection_screen_title()

        view.addSubview(list)
        list.snp.makeConstraints { make -> Void in
            make.edges.equalToSuperview()
        }

        collectionView = list
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadArticles()
    }

    private func loadArticles() {
        ArticlesService.shared.allArticles()
            .subscribe(onSuccess: { [weak self] articles in
                log.debug("Articles: \(articles)")
                self?.content = Content(items: articles.map { Item(isSelected: false, id: $0._id, title: $0.name) })
            }) { error in
                log.error("Error occurred: \(error)")
            }
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
        items[indexPath.row] = Item(isSelected: !item.isSelected, id: item.id, title: item.title)
        self.content = Content(items: items)
    }
}

extension SeekerItemSelectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width, height: Style.rowHeight)
//    }
}
