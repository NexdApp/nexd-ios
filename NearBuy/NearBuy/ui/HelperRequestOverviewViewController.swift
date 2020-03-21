//
//  ViewController.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SnapKit
import UIKit

class HelperRequestOverviewViewController: UIViewController {
    private var collectionView: UICollectionView?
    private var dataSource: DefaultDataSource? {
        didSet {
            collectionView?.dataSource = dataSource
        }
    }

    private var data: [User]? {
        didSet {
            dataSource = DefaultDataSource(items: data?.map { DefaultCellItem(iconColor: .green, text: $0.name) } ?? [], reuseIdentifier: DefaultCell.reuseIdentifier)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .white
        list.delegate = self
        list.register(DefaultCell.self, forCellWithReuseIdentifier: DefaultCell.reuseIdentifier)
        list.register(SectionHeaderView.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier);


        view.backgroundColor = .white
        title = R.string.localizable.buyer_request_overview_screen_title()

        view.addSubview(list)
        list.snp.makeConstraints { make -> Void in
            make.edges.equalToSuperview()
        }

        collectionView = list

        data = [
            User(name: "Sepp Berger", location: "München"),
            User(name: "Irmgard Engelhorn", location: "Berlin"),
            User(name: "Max Mustermann", location: "Hamburg"),
        ]
    }
}

extension HelperRequestOverviewViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        log.debug("TODO")
//        viewModel.prefetch(index: indexPath.row)
    }
}

extension HelperRequestOverviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60)
    }
}
