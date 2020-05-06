//
//  Dialog.swift
//  nexd
//
//  Created by Tobias Schröpf on 06.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation

struct Dialog: Identifiable {
    var id = UUID()
    let title: String
    let message: String
}
