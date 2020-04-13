//
//  FontResource+SwiftUI.swift
//  nexd
//
//  Created by Tobias Schröpf on 13.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Rswift
import SwiftUI

extension FontResource {
    func swiftui(size: CGFloat) -> Font {
        Font.custom(fontName, size: size)
    }
}
