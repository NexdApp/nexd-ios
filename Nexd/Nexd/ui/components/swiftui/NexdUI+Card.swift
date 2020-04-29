//
//  NexdUI+Card.swift
//  nexd
//
//  Created by Tobias Schröpf on 14.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

extension NexdUI {
    struct Card<Content: View>: View {
        let content: Content

        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }

        var body: some View {
            content
                .padding(8)
                .background(Color.white)
                .cornerRadius(10)
        }
    }
}

#if DEBUG
    struct Card_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                NexdUI.Card {
                    Text("Card")
                }
                .frame(width: 200, height: 100)
                .padding(20)
                .background(R.color.nexdGreen.color)
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
