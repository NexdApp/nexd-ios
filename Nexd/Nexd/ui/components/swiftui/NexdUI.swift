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
        static func back(text: Text = R.string.localizable.back_button_title.text, action: @escaping () -> Void) -> some View {
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

        static func cancel(text: Text = R.string.localizable.cancel_button_title.text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                text
                    .font(R.font.proximaNovaSoftMedium.font(size: 23))
                    .foregroundColor(R.color.darkButtonText.color)
            }
        }

        static func done(text: Text = R.string.localizable.done_button_title.text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                text
                    .font(R.font.proximaNovaSoftBold.font(size: 23))
                    .foregroundColor(R.color.darkButtonText.color)
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

        static func addButton(action: @escaping () -> Void) -> some View {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(R.color.lightButtonBackground.color)
                        .frame(width: 32, height: 32)
                        .shadow(color: R.color.shadow.color, radius: 4, x: 0, y: 4)

                    R.image.baseline_add_black_24pt.image
                        .resizable()
                        .foregroundColor(R.color.lightButtonIcon.color)
                        .frame(width: 24, height: 24)
                }
            }
        }

        static func deleteButton(action: @escaping () -> Void) -> some View {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(R.color.solidButtonBackground.color)
                        .frame(width: 32, height: 32)
                        .shadow(color: R.color.shadow.color, radius: 4, x: 0, y: 4)

                    R.image.baseline_delete_black_24pt.image
                        .resizable()
                        .foregroundColor(R.color.solidButtonIcon.color)
                        .frame(width: 24, height: 24)
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

        static func darkButton(text: Text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                text
                    .font(R.font.proximaNovaSoftBold.font(size: 28))
                    .foregroundColor(R.color.darkButtonBorder.color)
                    .padding([.leading, .trailing], 12)
            }
            .frame(maxHeight: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(R.color.darkButtonBorder.color, lineWidth: 2)
            )
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

        static func darkMainMenuButton(text: Text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    text
                        .font(R.font.proximaNovaSoftBold.font(size: 28))
                        .foregroundColor(R.color.darkButtonText.color)
                        .padding(.leading, 19)
                        .padding(.trailing, 8)

                    Spacer()

                    R.image.chevron.image
                        .foregroundColor(R.color.darkButtonBorder.color)
                        .padding(.trailing, 27)
                }
                .frame(height: 92)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(R.color.darkButtonBorder.color, lineWidth: 2)
                )
            }
        }

        static func lightMainMenuButton(text: Text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    text
                        .font(R.font.proximaNovaSoftBold.font(size: 28))
                        .foregroundColor(R.color.lightButtonText.color)
                        .padding(.leading, 19)
                        .padding(.trailing, 8)

                    Spacer()

                    R.image.chevron.image
                        .foregroundColor(R.color.nexdGreen.color)
                        .padding(.trailing, 27)
                }
                .frame(height: 92)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(R.color.nexdGreen.color, lineWidth: 2)
                )
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

        static func detailsText(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaSoftBold.font(size: 20))
                .foregroundColor(R.color.darkHeadingText.color)
        }

        static func sectionHeader(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaSoftBold.font(size: 25))
                .foregroundColor(R.color.headingText.color)
        }

        static func cardSectionHeader(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaSoftBold.font(size: 18))
                .foregroundColor(R.color.darkListItemTitle.color)
        }

        static func cardText(text: Text) -> some View {
            text
                .font(R.font.proximaNovaSoftBold.font(size: 18))
                .foregroundColor(R.color.listItemTitle.color)
        }

        static func cardPlaceholderText(text: Text) -> some View {
            text
                .font(R.font.proximaNovaSoftBold.font(size: 14))
                .foregroundColor(R.color.listItemDetailsText.color)
        }

        static func filterButtonDetailsText(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaSoftRegular.font(size: 14))
                .foregroundColor(R.color.filterButtonDetails.color)
        }

        static func suggestion(text: String, highlight: String?) -> some View {
            guard let highlight = highlight, let highlightRange = text.range(of: highlight, options: .caseInsensitive), !highlightRange.isEmpty else {
                return Text(text).notMatchingText()
            }

            let prefix = text[..<highlightRange.lowerBound]
            let match = text[highlightRange.lowerBound ..< highlightRange.upperBound]
            let suffix = text[highlightRange.upperBound ..< text.endIndex]

            return Text(prefix).notMatchingText()
                + Text(match).matchingText()
                + Text(suffix).notMatchingText()
        }

        static func matching(_ text: String) -> Text {
            Text(text).matchingText()
        }

        static func notMatching(_ text: String) -> Text {
            Text(text).notMatchingText()
        }
    }
}

extension Text {
    fileprivate func matchingText() -> Text {
        font(R.font.proximaNovaSoftBold.font(size: 16))
            .foregroundColor(R.color.matchingText.color)
    }

    fileprivate func notMatchingText() -> Text {
        font(R.font.proximaNovaSoftMedium.font(size: 16))
            .foregroundColor(R.color.notMatchingText.color)
    }
}

#if DEBUG
    struct NexdUI_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                NexdUI.Buttons.back {}
                    .padding(8)

                NexdUI.Buttons.default(text: R.string.localizable.checkout_button_title_complete.text, action: {})
                    .padding(8)

                NexdUI.Buttons.confirm {}
                    .padding(8)

//                NexdUI.Buttons.darkButton(text: Text("Dark Button"), action: {})
//                    .padding(8)

                NexdUI.Buttons.lightButton(text: Text("Light Button"), action: {})
                    .padding(8)

                NexdUI.Buttons.darkMainMenuButton(text: Text("Dark Main Menu Button!"), action: {})
                    .padding(8)

                NexdUI.Buttons.lightMainMenuButton(text: Text("Light Main Menu Button!"), action: {})
                    .padding(8)
                    .background(Color.white)

                NexdUI.Buttons.solidButton(text: Text("Dark Button"), action: {})
                    .padding(8)
                    .background(Color.white)

                NexdUI.Buttons.solidBackButton(action: {})
                    .background(Color.white)

                NexdUI.Texts.title(text: R.string.localizable.delivery_confirmation_screen_title.text)

                NexdUI.Texts.h2Dark(text: Text(R.string.localizable.delivery_confirmation_section_header("Anna")))
            }
            .background(R.color.nexdGreen.color)
            .previewLayout(.sizeThatFits)
        }
    }
#endif
