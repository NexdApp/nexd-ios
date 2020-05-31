//
//  SeekerArticleInputView.swift
//  nexd
//
//  Created by Tobias Schröpf on 28.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import NexdClient
import SwiftUI

// TODO: - order units, move "favorite" units to the top
// TODO: - only use "approved" items as suggestions

struct SeekerArticleInputView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    NexdUI.Texts.title(text: R.string.localizable.seeker_article_input_title.text)

                    HStack(alignment: .top, spacing: 8) {
                        VStack(spacing: 0) {
                            NexdUI.TextField(tag: 1,
                                             text: self.$viewModel.state.articleName,
                                             placeholder: R.string.localizable.seeker_item_selection_add_article_placeholer(),
                                             onChanged: { string in self.viewModel.articleNameChanged(text: string) },
                                             onCommit: { _ in self.viewModel.articleNameLostFocus() },
                                             inputConfiguration: NexdUI.InputConfiguration(hasDone: true))

                            self.viewModel.state.suggestions.map { suggestions in
                                VStack {
                                    ForEach(suggestions) { suggestion in
                                        NexdUI.Texts.suggestion(text: suggestion.name, highlight: self.viewModel.state.articleName)
                                            .padding([.leading, .trailing], 8)
                                            .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
                                            .contentShape(Rectangle())
                                            .onTapGesture { self.viewModel.suggestionAccepted(suggestion: suggestion) }
                                    }
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)

                        NexdUI.TextField(tag: 2,
                                         text: self.$viewModel.state.amount,
                                         placeholder: R.string.localizable.seeker_item_selection_article_amount_placeholer(),
                                         inputConfiguration: NexdUI.InputConfiguration(keyboardType: .numberPad, hasDone: true))
                            .frame(maxWidth: 110)

                        NexdUI.Buttons.darkButton(text: Text(self.viewModel.state.unit?.nameShort ?? "-")) {
                            self.viewModel.onUnitButtonTapped()
                        }
                        .frame(height: 48)
                    }

                    NexdUI.Texts.detailsText(text: R.string.localizable.seeker_article_input_description.text)
                        .padding(.top, 32)
                        .padding([.leading, .trailing], 23)

                    R.image.nexdIllustration1.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.top, 40)
                        .background(Circle().fill(Color.white))

                    Spacer()
                }
                .padding(.top, 70)
                .padding([.leading, .trailing], 20)
                .frame(width: geometry.size.width)

                if self.viewModel.state.isUnitsPickerVisible {
                    VStack {
                        Spacer()

                        VStack(spacing: 0) {
                            R.string.localizable.seeker_article_input_unit_picker_title.text
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(R.font.proximaNovaSoftBold.font(size: 35))
                                .foregroundColor(R.color.greetingSubline.color)

                            self.viewModel.itemSelectionViewState.units.map { units in
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
                    .contentShape(Rectangle())
                    .onTapGesture { self.viewModel.dismissUnitPicker() }
                }
            }
            .dismissingKeyboard()
            .onAppear { self.viewModel.bind() }
            .onDisappear { self.viewModel.unbind() }
            .withModalButtons(
                onCancel: { self.viewModel.cancelButtonTapped() },
                onDone: { self.viewModel.doneButtonTapped() }
            )
        }
    }
}

extension SeekerArticleInputView {
    class ViewModel: ObservableObject {
        class ViewState: ObservableObject {
            @Published var articleName: String?
            @Published var suggestions: [Article]?

            @Published var amount: String?

            @Published var unit: ItemSelectionViewState.Unit?
            @Published var isUnitsPickerVisible: Bool = false

            func asItem() -> ItemSelectionViewState.Item {
                let articleName: String = self.articleName ?? ""
                let amount: String = self.amount ?? "0"
                return ItemSelectionViewState.Item(article: nil, name: articleName, amount: Int64(amount) ?? 0, unit: unit)
            }

            static func from(item: ItemSelectionViewState.Item?) -> ViewState {
                let state = ViewState()

                if let item = item {
                    state.articleName = item.name
                    state.amount = String(item.amount)
                    state.unit = item.unit
                }

                return state
            }
        }

        private let navigator: ScreenNavigating
        private let articlesService: ArticlesService
        private let onDone: ((ItemSelectionViewState.Item) -> Void)?
        private let onCancel: (() -> Void)?

        @Published var itemSelectionViewState: ItemSelectionViewState

        private var cancellableSet = Set<AnyCancellable>()

        var state: ViewState

        private var articleNameInput = PassthroughSubject<String?, Never>()

        init(navigator: ScreenNavigating,
             articlesService: ArticlesService,
             itemSelectionViewState: ItemSelectionViewState,
             item: ItemSelectionViewState.Item?,
             onDone: ((ItemSelectionViewState.Item) -> Void)? = nil,
             onCancel: (() -> Void)? = nil) {
            self.navigator = navigator
            self.articlesService = articlesService
            state = ViewState.from(item: item)
            self.itemSelectionViewState = itemSelectionViewState
            self.onDone = onDone
            self.onCancel = onCancel
        }

        func cancelButtonTapped() {
            onCancel?()
        }

        func doneButtonTapped() {
            onDone?(state.asItem())
        }

        func articleNameChanged(text: String?) {
            articleNameInput.send(text)
        }

        func articleNameLostFocus() {
            state.suggestions = nil
        }

        func suggestionAccepted(suggestion: Article) {
            state.articleName = suggestion.name
            state.suggestions = nil

            if let unitId = suggestion.unitIdOrder?.first {
                state.unit = itemSelectionViewState.units?.first { $0.id == unitId }
            }
        }

        func onUnitButtonTapped() {
            UIApplication.shared.endEditing()
            state.isUnitsPickerVisible = true
        }

        func unitSelected(unit: ItemSelectionViewState.Unit) {
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

            articleNameInput
                .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
                .flatMap { [weak self] inputText -> AnyPublisher<[Article]?, Never> in
                    guard let self = self, let inputText = inputText, !inputText.isEmpty else {
                        return Just<[Article]?>(nil).eraseToAnyPublisher()
                    }

                    return self.articlesService.allArticles(limit: 5,
                                                            startsWith: inputText,
                                                            language: self.itemSelectionViewState.language,
                                                            onlyVerified: false)
                        .map { articles -> [Article]? in articles }
                        .publisher
                        .replaceError(with: nil)
                        .eraseToAnyPublisher()
                }
                .assign(to: \.suggestions, on: state)
                .store(in: &cancellableSet)

            self.cancellableSet = cancellableSet
        }

        func unbind() {
            cancellableSet = Set<AnyCancellable>()
        }
    }

    static func createScreen(viewModel: SeekerArticleInputView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: SeekerArticleInputView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}

#if DEBUG
    struct SeekerArticleInputView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = SeekerArticleInputView.ViewModel(navigator: PreviewNavigator(),
                                                             articlesService: ArticlesService(),
                                                             itemSelectionViewState: ItemSelectionViewState(),
                                                             item: nil)
            return Group {
                SeekerArticleInputView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.locale, .init(identifier: "de"))

                SeekerArticleInputView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                SeekerArticleInputView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
