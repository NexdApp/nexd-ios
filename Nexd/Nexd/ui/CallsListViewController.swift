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

class CallsListViewController: UIViewController {
    enum MyStyle {
        static let headerHeight: CGFloat = 60
        static let rowHeight: CGFloat = 40
    }

    struct Item {
        let call: Call

        var title: String {
            return call.sid
        }

        static func from(call: Call) -> Item {
            return Item(call: call)
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

extension CallsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let items = self.content?.items else { return }

        let transcribeCallVc = TranscribeCallViewController()
        transcribeCallVc.callSid = items[indexPath.row].call.sid
        navigationController?.pushViewController(transcribeCallVc, animated: true)
    }
}
