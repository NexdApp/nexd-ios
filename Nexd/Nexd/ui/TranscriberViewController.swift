//
//  TranscriberViewController.swift
//  nexd
//
//  Created by Tobias Schröpf on 05.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import RxSwift
import SnapKit
import UIKit

class TranscriberViewController: UIViewController {
    enum MyStyle {
        static let headerHeight: CGFloat = 60
        static let rowHeight: CGFloat = 40
    }

    struct Item {
        let title: String

        static func from(call: Call) -> Item {
            return Item(title: call.sid)
        }
    }

    struct Content {
        let items: [Item]
    }

    private var dataSource: DefaultDataSource? {
        didSet {
            collectionView?.dataSource = dataSource
        }
    }

    private var content: Content? {
        didSet {
            dataSource = DefaultDataSource(items: content?.items.map { DefaultCell.Item(icon: nil, text: $0.title) } ?? [])
        }
    }

    private let disposeBag = DisposeBag()
    private var collectionView: UICollectionView?

    lazy var gradient = GradientView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: MyStyle.rowHeight)

        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .clear
        list.delegate = self
        list.register(DefaultCell.self, forCellWithReuseIdentifier: DefaultCell.reuseIdentifier)

        view.addSubview(list)
        list.snp.makeConstraints { make -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }

        collectionView = list
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        CallsService.shared.allCalls()
            .subscribe(onSuccess: { [weak self] calls in
                log.debug("Calls recevied: \(calls)")
                self?.content = Content(items: calls.map { Item.from(call: $0) })
            }, onError: { error in
                log.error("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

extension TranscriberViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // nothing yet
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let content = self.content else { return }

        var items = content.items
        let item = items[indexPath.row]
        items[indexPath.row] = Item(title: item.title)
        self.content = Content(items: items)
    }
}
