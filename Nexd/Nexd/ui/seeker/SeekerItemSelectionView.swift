//
//  SeekerItemSelectionView.swift
//  nexd
//
//  Created by Tobias Schröpf on 24.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import NexdClient
import SwiftUI

struct SeekerItemSelectionView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            HStack {
                NexdUI.Texts.title(text: R.string.localizable.seeker_item_selection_screen_title.text)

                Spacer()

                NexdUI.Buttons.addButton {
                    self.viewModel.addItemEntryTapped()
                }
                .identified(by: .seekerItemSelectionAddButton)
            }
            .padding(.top, 70)
            .padding([.leading, .trailing], 20)

            ScrollView {
                if viewModel.state.items.isEmpty {
                    VStack {
                        NexdUI.Texts.detailsText(text: R.string.localizable.seeker_item_selection_no_items_text.text)
                            .padding([.leading, .trailing], 35)

                        R.image.nexdIllustration2.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .padding(.top, 40)
                            .background(Circle().fill(Color.white))
                    }
                } else {
                    NexdUI.EditableArticleList(items: viewModel.state.items,
                                               onDelete: { self.viewModel.removeItem(item: $0) },
                                               onEdit: { self.viewModel.editItem(item: $0) })
                        .padding([.leading, .trailing], 35)
                }
            }

            Spacer()

            NexdUI.Buttons.confirm(text: R.string.localizable.seeker_item_selection_confirm_button_title.text) {
                self.viewModel.confirmButtonTapped()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 33)
            .padding(.bottom, 53)
            .padding(.leading, 35)
        }
        .onAppear { self.viewModel.bind() }
        .onDisappear { self.viewModel.unbind() }
        .withBackButton { self.viewModel.backButtonTapped() }
    }
}

extension SeekerItemSelectionView {
    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating
        private let articlesService: ArticlesService

        private var cancellableSet = Set<AnyCancellable>()

        var state: HelpRequestCreationState = HelpRequestCreationState()

        private var articleNameInput = PassthroughSubject<String?, Never>()

        init(navigator: ScreenNavigating, articlesService: ArticlesService) {
            self.navigator = navigator
            self.articlesService = articlesService
        }

        func backButtonTapped() {
            navigator.goBack()
        }

        func editItem(item: HelpRequestCreationState.Item) {
            navigator.toArticleInput(helpRequestCreationState: state, with: item) { [weak self] updatedtem in
                guard let self = self else { return }

                log.debug("Item updated: \(updatedtem)")
                guard let existingItem = self.state.items.firstIndex(where: { $0.id == item.id }) else {
                    self.state.items.append(updatedtem)
                    return
                }

                self.state.items[existingItem] = updatedtem
            }
        }

        func removeItem(item: HelpRequestCreationState.Item) {
            state.items.removeAll { $0.id == item.id }
        }

        func addItemEntryTapped() {
            navigator.toArticleInput(helpRequestCreationState: state, with: nil) { [weak self] item in
                self?.state.items.append(item)
            }
        }

        func confirmButtonTapped() {
            navigator.toRequestConfirmation(state: state)
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

            state.objectWillChange
                .sink { [weak self] in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellableSet)

            articlesService.allUnits(language: state.language)
                .publisher
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        log.error("Loading units failed: \(error)")
                        return
                    }
                }, receiveValue: { [weak self] units in
                    log.debug("Received units: \(units)")
                    self?.state.units = units
                })
                .store(in: &cancellableSet)

            self.cancellableSet = cancellableSet
        }

        func unbind() {
            cancellableSet = Set<AnyCancellable>()
        }
    }

    static func createScreen(viewModel: SeekerItemSelectionView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: SeekerItemSelectionView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}

#if DEBUG
    struct SeekerItemSelectionView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = SeekerItemSelectionView.ViewModel(navigator: PreviewNavigator(), articlesService: ArticlesService())
            return Group {
                SeekerItemSelectionView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.locale, .init(identifier: "de"))

                SeekerItemSelectionView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                SeekerItemSelectionView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
