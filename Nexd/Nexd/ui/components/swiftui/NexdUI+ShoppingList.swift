//
//  NexdUI+ShoppingList.swift
//  nexd
//
//  Created by Tobias Schröpf on 02.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import SwiftUI

extension NexdUI {
    struct ShoppingListItemView: View {
        let item: HelpRequestArticle
        let unit: NexdClient.Unit?
        let onTapped: () -> Void

        var body: some View {
            HStack {
                OptionalView(item.article) { article in
                    NexdUI.Texts.cardText(text: Text(article.name))
                }

                Spacer()

                OptionalView(item.articleCount) { articleCount in
                    NexdUI.Texts.cardPlaceholderText(text: Text(String(articleCount)))
                }

                OptionalView(unit) { unit in
                    NexdUI.Texts.cardPlaceholderText(text: Text(unit.nameOne))
                }
            }
            .onTapGesture { self.onTapped() }
        }
    }

    struct ShoppingList: View {
        let items: [HelpRequestArticle]
        let units: [NexdClient.Unit]?
        let onTapped: ((HelpRequestArticle) -> Void)?

        var body: some View {
            VStack(spacing: 12) {
                ForEach(items) { item in
                    NexdUI.ShoppingListItemView(item: item,
                                                unit: self.units?.first { $0.id == item.unitId },
                                                onTapped: { self.onTapped?(item) })
                }
            }
        }
    }
}
