//
//  DataSource.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1
        switch kind {
        // 2
        case UICollectionView.elementKindSectionHeader:
            // 3
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? SectionHeaderView
            else {
                fatalError("Invalid view type")
            }

            headerView.label.text = "Hello World"
            return headerView
        default:
            // 4
            assert(false, "Invalid element type")
        }
    }
}
