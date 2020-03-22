//
//  ViewController.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit

class HelperRequestOverviewViewController: UIViewController {
    enum Style {
        static let headerHeight: CGFloat = 60
        static let rowHeight: CGFloat = 40
        static let buttonHeight: CGFloat = 52
    }

    struct Request {
        let title: String
    }

    struct Content {
        let acceptedRequests: [Request]
        let availableRequests: [Request]
    }

    private let disposeBag = DisposeBag()

    private var gradient = GradientView()
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
        list.backgroundColor = .clear
        list.delegate = self
        list.register(DefaultCell.self, forCellWithReuseIdentifier: DefaultCell.reuseIdentifier)
        list.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)

        title = R.string.localizable.helper_request_overview_screen_title()

        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(list)
        list.snp.makeConstraints { make -> Void in
            make.edges.equalToSuperview()
        }

        collectionView = list
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        RequestService.shared.openRequests()
            .subscribe(onSuccess: { [weak self] openRequests in
                log.debug("Open requests: \(openRequests)")

                let content = Content(acceptedRequests: [],
                                      availableRequests: openRequests.map {
//                                        let name = $0.requester?.lastName ?? R.string.localizable.helper_request_overview_unknown_requester()

                                        let name = "Requester: \($0.requesterId)"
                                        return Request(title: name)
                })

                self?.content = content
            }) { error in
                log.error("Request failed: \(error)")
            }
            .disposed(by: disposeBag)
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
