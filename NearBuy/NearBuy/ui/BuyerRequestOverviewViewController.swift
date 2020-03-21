//
//  ViewController.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SnapKit
import UIKit

class BuyerRequestOverviewViewController: UIViewController {
    private var collectionView: UICollectionView?
    private let dataSource = DefaultDataSource(items: [DefaultCellItem(color: .blue, text: "TEST"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE"),
                                                       DefaultCellItem(color: .green, text: "NASE")], reuseIdentifier: "reuseIdentifier")

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .white
        list.dataSource = dataSource
        list.delegate = self
        list.register(DefaultCell.self, forCellWithReuseIdentifier: "reuseIdentifier")

        view.backgroundColor = .white
        self.title = R.string.localizable.buyer_REQUEST_OVERVIEW_SCREEN_TITLE()

        view.addSubview(list)
        list.snp.makeConstraints { make -> Void in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
//            make.topMargin.equalTo(50)
        }

        self.collectionView = list
    }
}

extension BuyerRequestOverviewViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        log.debug("nase")
//        viewModel.prefetch(index: indexPath.row)
    }
}

extension BuyerRequestOverviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60)
    }
}

class DataSource<ItemType>: NSObject, UICollectionViewDataSource {
    let reuseIdentifier: String
    var items: [ItemType]
    let cellBinder: (ItemType, UICollectionViewCell) -> Void

    init(reuseIdentifier: String,
         items: [ItemType],
         cellBinder: @escaping (ItemType, UICollectionViewCell) -> Void) {
        self.reuseIdentifier = reuseIdentifier
        self.items = items
        self.cellBinder = cellBinder
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        cellBinder(items[indexPath.row], cell)
        return cell
    }
}

class DefaultDataSource: DataSource<DefaultCellItem> {
    init(items: [DefaultCellItem], reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier, items: items) { item, cell in
            if let cell = cell as? DefaultCell {
                cell.bind(to: item)
            }
        }
    }
}

struct DefaultCellItem: Hashable {
    let color: UIColor
    let text: String
}

class DefaultCell: UICollectionViewCell {
    lazy var avatar = UIView()
    lazy var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(avatar)
        contentView.addSubview(label)

        avatar.snp.makeConstraints { make -> Void in
            make.width.height.equalTo(20)
            make.leftMargin.equalTo(8)
            make.centerY.equalToSuperview()
        }

        label.snp.makeConstraints { make -> Void in
            make.rightMargin.equalTo(8)
            make.left.equalTo(avatar).offset(8)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(to item: DefaultCellItem) {
        avatar.backgroundColor = .red
        label.text = item.text
        backgroundColor = item.color.withAlphaComponent(0.3)
    }
}
