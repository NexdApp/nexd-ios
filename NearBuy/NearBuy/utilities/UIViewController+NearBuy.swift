//
//  UIViewController+NearBuy.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension UIViewController {
    func showError(title: String, message: String, handler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.error_button_ok(),
                                          style: .cancel,
                                          handler: { _ in handler?() }
            ))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func showSuccess(title: String, message: String, handler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.error_button_ok(),
                                          style: .default,
                                          handler: { _ in handler?() }
            ))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
