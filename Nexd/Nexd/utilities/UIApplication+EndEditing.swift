//
//  UIApplication+EndEditing.swift
//  nexd
//
//  Created by Tobias Schröpf on 16.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension UIApplication {
    func endEditing() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
        keyWindow?.endEditing(true)
    }
}
