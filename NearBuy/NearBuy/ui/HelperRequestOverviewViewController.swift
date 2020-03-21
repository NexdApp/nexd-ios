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
    enum Style {
        static let headerHeight: CGFloat = 60
        static let rowHeight: CGFloat = 40
    }
    struct Request {
        let title: String
    }

    struct Content {
        let acceptedRequests: [Request]
        let availableRequests: [Request]
    }

    private var collectionView: UICollectionView?
    private var dataSource: DefaultSectionedDataSource<DefaultCellItem>? {
        didSet {
            collectionView?.dataSource = dataSource
        }
    }

    private var content: Content? {
        didSet {
            var sections = [DefaultSectionedDataSource<DefaultCellItem>.Section]()
            if let content = content {
                let acceptedRequestsSection = DefaultSectionedDataSource<DefaultCellItem>.Section(reuseIdentifier: DefaultCell.reuseIdentifier,
                                                                                                  title: R.string.localizable.helper_request_overview_heading_accepted_section(),
                                                                                                  items: content.acceptedRequests.map { DefaultCellItem(iconColor: .green, text: $0.title) })
                let availableRequestsSection = DefaultSectionedDataSource<DefaultCellItem>.Section(reuseIdentifier: DefaultCell.reuseIdentifier,
                                                                                                   title: R.string.localizable.helper_request_overview_heading_available_section(),
                                                                                                   items: content.availableRequests.map { DefaultCellItem(iconColor: .red, text: $0.title) })

                sections.append(acceptedRequestsSection)
                sections.append(availableRequestsSection)
            }

            dataSource = DefaultSectionedDataSource(sections: sections, cellBinder: { item, cell in
                if let cell = cell as? DefaultCell {
                    cell.bind(to: item)
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: view.frame.size.width, height: Style.headerHeight)
        layout.itemSize = CGSize(width: view.frame.size.width, height: Style.rowHeight)

        let list = UICollectionView(frame: .zero, collectionViewLayout: layout)
        list.backgroundColor = .white
        list.delegate = self
        list.register(DefaultCell.self, forCellWithReuseIdentifier: DefaultCell.reuseIdentifier)
        list.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)

        view.backgroundColor = .white
        title = R.string.localizable.helper_request_overview_screen_title()

        view.addSubview(list)
        list.snp.makeConstraints { make -> Void in
            make.edges.equalToSuperview()
        }

        collectionView = list

        content = Content(acceptedRequests: [Request(title: "accepted eins"), Request(title: "accepted zwei")],
                          availableRequests: [Request(title: "available eins"), Request(title: "available zwei")])
    }
}

extension HelperRequestOverviewViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // nothing yet
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        log.debug("ZEFIX - \(indexPath)")
    }
}

extension HelperRequestOverviewViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width, height: Style.rowHeight)
//    }
}
