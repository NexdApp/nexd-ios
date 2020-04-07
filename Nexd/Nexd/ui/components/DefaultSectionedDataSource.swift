//
//  DefaultSectionedDataSource.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class DefaultSectionedDataSource<ItemType>: NSObject, UICollectionViewDataSource {
    struct Section {
        let reuseIdentifier: String
        let title: String
        let items: [ItemType]
    }

    var sections: [Section]
    let cellBinder: (ItemType, UICollectionViewCell) -> Void

    init(sections: [Section],
         cellBinder: @escaping (ItemType, UICollectionViewCell) -> Void) {
        self.sections = sections
        self.cellBinder = cellBinder
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.reuseIdentifier, for: indexPath)

        let item = section.items[indexPath.row]
        cellBinder(item, cell)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? SectionHeaderView
            else {
                fatalError("Invalid view type")
            }

            headerView.label.styleHeader()
            headerView.label.attributedText = sections[indexPath.section].title.asHeader()
            return headerView
        default:
            fatalError("Invalid element type")
        }
    }
}
