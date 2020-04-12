//
//  CheckoutListView.swift
//  nexd
//
//  Created by Tobias Schröpf on 12.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Rswift
import SwiftUI

extension FontResource {
    func swiftui(size: CGFloat) -> Font {
        Font.custom(fontName, size: size)
    }
}

extension ColorResource {
    func swiftui() -> Color {
        Color(name)
    }
}

struct TestArticle {
    let articleId: Int
    let name: String
}

struct Card {
    let cardId: Int
    let title: String
    let articles: [TestArticle]
    let answer: String

    static var example: Card {
        Card(cardId: 123, title: "Anna", articles: [TestArticle(articleId: 1, name: "Apfel"), TestArticle(articleId: 2, name: "Birnen")], answer: "Jodie Whittaker")
    }
}

struct CardView: View {
    let card: Card

    var body: some View {
        VStack(alignment: .leading) {
            Text(card.title)
                .font(R.font.proximaNovaSoftBold.swiftui(size: 35))
                .foregroundColor(.white)

            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white)

                VStack {
                    ForEach(card.articles, id: \.articleId) { article in
                        HStack {
                            Text(article.name)
                                .font(R.font.proximaNovaSoftRegular.swiftui(size: 18))
                                .foregroundColor(R.color.listItemTitle.swiftui())
                                .frame(height: 52)

                            Spacer()

                            Text("5")
                                .font(R.font.proximaNovaSoftRegular.swiftui(size: 14))
                                .foregroundColor(R.color.listItemDetailsText.swiftui())
                                .frame(height: 52)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(8)
            }
        }
    }
}

struct CheckoutListView: View {
    var cards: [Card] = [.example, .example]

    var body: some View {
        List {
            ForEach(cards, id: \.cardId) { card in
                CardView(card: card)
            }
        }
    }
}

#if DEBUG
    struct CheckoutListView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                CheckoutListView(cards: [.example, .example, .example, .example])
                    .environment(\.colorScheme, .light)

                CheckoutListView(cards: [.example, .example, .example, .example])
                    .environment(\.colorScheme, .dark)
            }
        }
    }
#endif
