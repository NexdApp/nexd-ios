//
//  Navigator.swift
//  nexd
//
//  Created by Tobias Schröpf on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse
import UIKit

protocol ScreenNavigating {
    func toShoppingListOptions()
}

class Navigator {
    let navigationController: UINavigationController
    let mainPageViewController: MainPageViewController

    init(navigationController: UINavigationController, mainPageViewController: MainPageViewController) {
        self.navigationController = navigationController
        self.mainPageViewController = mainPageViewController
    }
}

extension Navigator: ScreenNavigating {
    func toShoppingListOptions() {
        navigationController.pushViewController(mainPageViewController, animated: true)
    }
}
