//
//  HelperRequestFilterSettings.swift
//  nexd
//
//  Created by Tobias Schröpf on 27.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import SwiftUI

struct HelperRequestFilterSettingsView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            Text("Hello World")
        }
    }
}

extension HelperRequestFilterSettingsView {
    struct Result {
        let zipCode: String
    }

    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating

        private let onFinished: (Result) -> Void

        init(navigator: ScreenNavigating,
             onFinished: @escaping ((Result) -> Void)) {
            self.navigator = navigator
            self.onFinished = onFinished
        }

        func confirmButtonTapped() {}
    }

    static func createScreen(viewModel: HelperRequestFilterSettingsView.ViewModel) -> ModalScreen<HelperRequestFilterSettingsView> {
        let screen = ModalScreen(rootView: HelperRequestFilterSettingsView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}
