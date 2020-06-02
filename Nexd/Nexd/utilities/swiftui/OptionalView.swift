//
//  OptionalView.swift
//  nexd
//
//  Created by Tobias Schröpf on 02.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

struct OptionalView<Value, Content>: View where Content: View {
    var content: (Value) -> Content
    var value: Value

    init?(_ value: Value?, @ViewBuilder content: @escaping (Value) -> Content) {
        guard let value = value else { return nil }

        self.value = value
        self.content = content
    }

    var body: some View {
        content(value)
    }
}

extension Optional where Wrapped: View {
    func whenNil<T: View>(_ transform: () -> T) -> AnyView? {
        switch self {
        case .none:
            return AnyView(transform())
        case let .some(view):
            return AnyView(view)
        }
    }
}
