//
//  DataSource.swift
//  Nexd
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
}
