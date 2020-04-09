//
//  Navigator.swift
//  nexd
//
//  Created by Tobias Schröpf on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

protocol ScreenNavigating {
    func toShoppingListOptions()
}

class Navigator {
    var navigationController: UINavigationController?
}

extension Navigator: ScreenNavigating {
    func toShoppingListOptions() {

    }
}
