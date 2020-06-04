//
//  NexdUI+ArticleList.swift
//  nexd
//
//  Created by Tobias Schröpf on 31.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

extension NexdUI {
    struct EditableArticleListItem: View {
        let item: HelpRequestCreationState.Item
        let onDelete: () -> Void
        let onEdit: () -> Void

        var body: some View {
            NexdUI.Card {
                HStack {
                    NexdUI.Texts.cardText(text: Text(item.name))

                    Spacer()

                    NexdUI.Texts.cardPlaceholderText(text: Text(String(item.amount)))

                    item.unit.map { unit in
                        NexdUI.Texts.cardPlaceholderText(text: Text(unit.nameShort))
                    }

                    NexdUI.Buttons.deleteButton {
                        self.onDelete()
                    }
                }
            }
            .onTapGesture { self.onEdit() }
        }
    }

    struct EditableArticleList: View {
        let items: [HelpRequestCreationState.Item]
        let onDelete: (HelpRequestCreationState.Item) -> Void
        let onEdit: (HelpRequestCreationState.Item) -> Void

        var body: some View {
            VStack(spacing: 12) {
                ForEach(items) { item in
                    NexdUI.EditableArticleListItem(item: item,
                                                   onDelete: { self.onDelete(item) },
                                                   onEdit: { self.onEdit(item) })
                }
            }
        }
    }
}
