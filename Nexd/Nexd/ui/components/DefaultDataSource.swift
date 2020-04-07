//
//  DefaultDataSource.swift
//  NearNexdBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation

class DefaultDataSource: DataSource<DefaultCell.Item> {
    init(items: [DefaultCell.Item]) {
        super.init(reuseIdentifier: DefaultCell.reuseIdentifier, items: items) { item, cell in
            if let cell = cell as? DefaultCell {
                cell.bind(to: item)
            }
        }
    }
}
