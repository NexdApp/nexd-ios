//
//  NexdUI.swift
//  nexd
//
//  Created by Tobias Schröpf on 13.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Rswift
import SwiftUI

enum NexdUI {
    enum Buttons {
        static func `default`(text: Text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    text
                        .font(R.font.proximaNovaSoftBold.font(size: 35))
                        .foregroundColor(R.color.positiveButtonText.color)

                    R.image.chevron.image
                        .foregroundColor(R.color.positiveButtonText.color)
                }
            }
        }
    }

    enum Headings {
        static func title(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaSoftBold.font(size: 35))
                .foregroundColor(R.color.headingText.color)
        }

        static func h2Dark(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaSoftBold.font(size: 25))
                .foregroundColor(R.color.darkHeadingText.color)
        }
    }

    struct Card<Content: View>: View {
        let content: Content

        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white)

                content
                    .padding(8)
            }
        }
    }
}

#if DEBUG
    struct NexdUI_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                NexdUI.Buttons.default(text: R.string.localizable.checkout_button_title_complete.text, action: {})
                    .background(R.color.nexdGreen.color)

                NexdUI.Headings.title(text: R.string.localizable.delivery_confirmation_screen_title.text)
                    .background(R.color.nexdGreen.color)

                NexdUI.Headings.h2Dark(text: Text(R.string.localizable.delivery_confirmation_section_header("Anna")))
                    .background(R.color.nexdGreen.color)

                NexdUI.Card {
                    Text("Card")
                }
                .padding(20)
                .background(R.color.nexdGreen.color)
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
