//
//  ErrorOverlay.swift
//  nexd
//
//  Created by Tobias Schröpf on 04.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import NexdClient
import SwiftUI

struct ErrorOverlay: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        return VStack(alignment: .leading, spacing: 30) {
            NexdUI.Texts.title(text: R.string.localizable.overlay_backend_error_communication_failed_title.text)
                .padding(.top, 70)

            VStack(alignment: .center, spacing: 30) {
                R.image.nexdIllustration1.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 40)
                    .background(Circle().fill(Color.white))

                NexdUI.Texts.detailsText(text: R.string.localizable.overlay_backend_error_communication_failed_message.text)
                    .padding(.top, 40)

                Spacer()
            }

            NexdUI.Buttons.default(text: R.string.localizable.overlay_backend_error_communication_failed_retry.text) {
                self.viewModel.retryTapped()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 0)
            .padding(.bottom, 40)
        }
        .padding([.leading, .trailing], 20)
        .onAppear { self.viewModel.bind() }
        .onDisappear { self.viewModel.unbind() }
    }
}

extension ErrorOverlay {
    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating
        private let userService: UserService

        private var cancellableSet: Set<AnyCancellable>?
        private let retryEvents = PassthroughSubject<Void, Never>()
        private let onErrorVanished: (() -> Void)

        init(navigator: ScreenNavigating, userService: UserService, onErrorVanished: @escaping () -> Void) {
            self.navigator = navigator
            self.userService = userService
            self.onErrorVanished = onErrorVanished
        }

        func retryTapped() {
            retryEvents.send(())
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

            let userService = self.userService
            let callback = self.onErrorVanished

            cancellableSet.insert(
                retryEvents
                    .flatMap {
                        userService.findMe()
                            .map { _ in callback() }
                            .publisher
                            .replaceError(with: ())
                    }
                    .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            )

            self.cancellableSet = cancellableSet
        }

        func unbind() {
            cancellableSet = nil
        }
    }

    static func createScreen(viewModel: ErrorOverlay.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: ErrorOverlay(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}
