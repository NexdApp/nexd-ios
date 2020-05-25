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

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// TODO: - send correct locale for backend requests
// TODO: - check if automatic selection of unit works when a suggestion is accepted
// TODO: - order units, move "favorite" units to the top

struct SeekerItemSelectionView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ZStack {
                VStack {
                    HStack(alignment: .top) {
                        VStack(spacing: 0) {
                            NexdUI.TextField(tag: 1,
                                             text: $viewModel.state.articleName,
                                             placeholder: R.string.localizable.seeker_item_selection_add_article_placeholer(),
                                             onChanged: { string in self.viewModel.articleNameChanged(text: string) },
                                             inputConfiguration: NexdUI.InputConfiguration(hasDone: true))

                            viewModel.state.suggestions.map { suggestions in
                                VStack {
                                    ForEach(suggestions) { suggestion in
                                        NexdUI.Texts.defaultDark(text: Text(suggestion.name))
                                            .frame(maxWidth: .infinity, minHeight: 40)
                                            .contentShape(Rectangle())
                                            .onTapGesture { self.viewModel.suggestionAccepted(suggestion: suggestion) }
                                    }
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)

                        NexdUI.TextField(tag: 2,
                                         text: $viewModel.state.amount,
                                         placeholder: R.string.localizable.seeker_item_selection_article_amount_placeholer(),
                                         inputConfiguration: NexdUI.InputConfiguration(keyboardType: .numberPad, hasDone: true))

                        NexdUI.Buttons.darkButton(text: Text(viewModel.state.unit?.nameShort ?? "???")) {
                            self.viewModel.onUnitButtonTapped()
                        }
                        .frame(height: 48)
                    }
                    .padding(.top, 70)
                    .padding([.leading, .trailing], 12)

                    Spacer()
                }

                if self.viewModel.state.isUnitsPickerVisible {
                    VStack {
                        Spacer()

                        VStack(spacing: 0) {
                            viewModel.state.units.map { units in
                                List(units) { unit in
                                    NexdUI.Texts.defaultDark(text: Text("\(unit.name) (\(unit.nameShort))"))
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                        .contentShape(Rectangle())
                                        .onTapGesture { self.viewModel.unitSelected(unit: unit) }
                                }
                                .frame(maxWidth: .infinity, maxHeight: 320)
                            }
                        }
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(10, corners: [.topLeft, .topRight])
                    }
                    .transition(.move(edge: .bottom))
                    .contentShape(Rectangle())
                    .onTapGesture { self.viewModel.dismissUnitPicker() }
                }
            }
        }
        .dismissingKeyboard()
        .onAppear { self.viewModel.bind() }
        .onDisappear { self.viewModel.unbind() }
        .withBackButton { self.viewModel.backButtonTapped() }
    }
}

extension Article: Identifiable {}

extension SeekerItemSelectionView {
    class ViewModel: ObservableObject {
        struct Unit: Identifiable {
            let id: Int64?
            let name: String
            let nameShort: String
        }

        class ViewState: ObservableObject {
            @Published var articleName: String?
            @Published var acceptedSuggestion: Article?
            @Published var suggestions: [Article]?

            @Published var amount: String?

            @Published var unit: Unit?
            @Published var units: [Unit]?
            @Published var isUnitsPickerVisible: Bool = false
        }

        private let navigator: ScreenNavigating
        private let articlesService: ArticlesService

        private var cancellableSet = Set<AnyCancellable>()

        var state: ViewState = ViewState()

        init(navigator: ScreenNavigating, articlesService: ArticlesService) {
            self.navigator = navigator
            self.articlesService = articlesService
        }

        func backButtonTapped() {
            navigator.goBack()
        }

        func articleNameChanged(text: String?) {
            state.acceptedSuggestion = nil

            guard let text = text, !text.isEmpty else {
                state.suggestions = nil
                return
            }

            articlesService.allArticles(limit: 5, startsWith: text, language: .de, onlyVerified: false)
                .publisher
                .map { articles -> [Article]? in articles }
                .replaceError(with: nil)
                .assign(to: \.suggestions, on: state)
                .store(in: &cancellableSet)
        }

        func suggestionAccepted(suggestion: Article) {
            state.articleName = suggestion.name
            state.acceptedSuggestion = suggestion
            state.suggestions = nil

            if let unitId = suggestion.unitIdOrder?.first {
                state.unit = state.units?.first { $0.id == unitId }
            }
        }

        func onUnitButtonTapped() {
            UIApplication.shared.endEditing()
            state.isUnitsPickerVisible = true
        }

        func unitSelected(unit: Unit) {
            state.unit = unit
            dismissUnitPicker()
        }

        func dismissUnitPicker() {
            state.isUnitsPickerVisible = false
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

            state.objectWillChange
                .sink { [weak self] in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellableSet)

            articlesService.allUnits(language: .de)
                .publisher
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        log.error("Loading units failed: \(error)")
                        return
                    }
                }) { [weak self] units in
                    log.debug("Received units: \(units)")
                    self?.state.units = units
                        .sorted { first, second -> Bool in first.name < second.name }
                        .map { unit in Unit(id: unit.id, name: unit.name, nameShort: unit.nameShort) }
                }
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
