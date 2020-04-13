//
//  UICollectionViewController+Nexd.swift
//  nexd
//
//  Created by Tobias Schröpf on 12.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift
import UIKit

extension UICollectionView {
    func registerCell(class cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: "\(cellClass)")
    }
}

extension Reactive where Base: UICollectionView {
    public func items<Sequence: Swift.Sequence, Cell: UICollectionViewCell, Source: ObservableType>
    (class cellType: Cell.Type = Cell.self)
        -> (_ source: Source)
        -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
        -> Disposable where Source.Element == Sequence {
            return items(cellIdentifier: "\(cellType)", cellType: cellType)
        }
}
