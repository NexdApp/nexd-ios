//
//  CheckoutListView.swift
//  nexd
//
//  Created by Tobias Schröpf on 12.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

struct CardView: View {
    let request: CheckoutViewController.Request

    var body: some View {
        VStack(alignment: .leading) {
            Text(request.title)
                .font(R.font.proximaNovaSoftBold.font(size: 35))
                .foregroundColor(.white)

            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white)

                VStack {
                    ForEach(request.articles, id: \.itemId) { article in
                        HStack {
                            Text(article.name)
                                .font(R.font.proximaNovaSoftRegular.font(size: 18))
                                .foregroundColor(R.color.listItemTitle.color)
                                .frame(height: 52)

                            Spacer()

                            article.count.map { count in
                                Text("\(count)")
                                    .font(R.font.proximaNovaSoftRegular.font(size: 14))
                                    .foregroundColor(R.color.listItemDetailsText.color)
                                    .frame(height: 52)
                            }
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
    var requests: [CheckoutViewController.Request]

    var body: some View {
        return List {
            ForEach(requests, id: \.requestId) { request in
                CardView(request: request)
            }
        }
    }
}

extension CheckoutViewController.Request {
    static var example: CheckoutViewController.Request {
        return CheckoutViewController.Request(requestId: 0, title: "asdf",
                                              articles: [CheckoutViewController.Item(itemId: 1, name: "Nase", count: 23),
                                                         CheckoutViewController.Item(itemId: 2, name: "Apfel", count: 42)])
    }
}

#if DEBUG
    struct CheckoutListView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                CheckoutListView(requests: [.example, .example, .example, .example])
                    .environment(\.colorScheme, .light)

                CheckoutListView(requests: [.example, .example, .example, .example])
                    .environment(\.colorScheme, .dark)
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
