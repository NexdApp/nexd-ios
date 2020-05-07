//
//  NexdUI.swift
//  nexd
//
//  Created by Tobias Schröpf on 13.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import Rswift
import SwiftUI

enum NexdUI {
    enum Buttons {
        static func back(text: Text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    R.image.chevron_left.image
                        .foregroundColor(R.color.darkButtonText.color)
                    text
                        .font(R.font.proximaNovaSoftBold.font(size: 23))
                        .foregroundColor(R.color.darkButtonText.color)
                }
            }
        }

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

        static func confirm(action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    R.string.localizable.confirm_button_title.text
                        .font(R.font.proximaNovaSoftBold.font(size: 35))
                        .foregroundColor(R.color.positiveButtonText.color)

                    R.image.chevron.image
                        .foregroundColor(R.color.positiveButtonText.color)
                }
            }
        }

        static func lightButton(text: Text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    text
                        .font(R.font.proximaNovaSoftBold.font(size: 25))
                        .foregroundColor(R.color.lightButtonText.color)
                        .padding(.leading, 29)
                        .padding(.trailing, 8)

                    Spacer()

                    R.image.chevron.image
                        .foregroundColor(R.color.lightButtonIcon.color)
                        .padding(.trailing, 27)
                }
                .frame(height: 70)
                .background(R.color.lightButtonBackground.color)
                .cornerRadius(10)
                .shadow(color: R.color.shadow.color, radius: 4, x: 0, y: 4)
            }
        }

        static func solidButton(text: Text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    text
                        .font(R.font.proximaNovaSoftBold.font(size: 25))
                        .foregroundColor(R.color.solidButtonText.color)
                        .padding(.leading, 29)
                        .padding(.trailing, 8)

                    Spacer()

                    R.image.chevron.image
                        .foregroundColor(R.color.solidButtonIcon.color)
                        .padding(.trailing, 27)
                }
                .frame(height: 70)
                .background(R.color.solidButtonBackground.color)
                .cornerRadius(10)
                .shadow(color: R.color.shadow.color, radius: 4, x: 0, y: 4)
            }
        }

        static func solidBackButton(action: @escaping () -> Void) -> some View {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(R.color.solidButtonBackground.color)
                        .frame(width: 32, height: 32)
                        .shadow(color: R.color.shadow.color, radius: 4, x: 0, y: 4)

                    R.image.chevron_left.image
                        .resizable()
                        .foregroundColor(R.color.solidButtonIcon.color)
                        .frame(width: 10, height: 17)
                }
            }
            .position(x: 28, y: 28)
        }
    }

    enum Texts {
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

        static func defaultDark(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaSoftBold.font(size: 16))
                .foregroundColor(R.color.darkHeadingText.color)
        }
    }
}

#if DEBUG
    struct NexdUI_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                NexdUI.Buttons.back(text: Text("Back"), action: {})

                NexdUI.Buttons.default(text: R.string.localizable.checkout_button_title_complete.text, action: {})

                NexdUI.Buttons.confirm { }

                NexdUI.Buttons.lightButton(text: Text("Light Button"), action: {})

                NexdUI.Buttons.solidButton(text: Text("Dark Button"), action: {})
                    .background(Color.white)

                NexdUI.Texts.title(text: R.string.localizable.delivery_confirmation_screen_title.text)

                NexdUI.Texts.h2Dark(text: Text(R.string.localizable.delivery_confirmation_section_header("Anna")))
            }
            .background(R.color.nexdGreen.color)
            .previewLayout(.sizeThatFits)
        }
    }
#endif
