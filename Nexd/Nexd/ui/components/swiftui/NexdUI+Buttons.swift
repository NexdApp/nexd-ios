//
//  NexdUI+Buttons.swift
//  nexd
//
//  Created by Tobias Schröpf on 04.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

extension NexdUI {
    enum Buttons {
        static func back(text: Text = R.string.localizable.back_button_title.text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    R.image.chevron_left.image
                        .foregroundColor(R.color.darkButtonText.color)
                    text
                        .font(R.font.proximaNovaBold.font(size: 23))
                        .foregroundColor(R.color.darkButtonText.color)
                }
            }
        }

        static func cancel(text: Text = R.string.localizable.cancel_button_title.text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                text
                    .font(R.font.proximaNovaRegular.font(size: 23))
                    .foregroundColor(R.color.darkButtonText.color)
            }
        }

        static func done(text: Text = R.string.localizable.done_button_title.text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                text
                    .font(R.font.proximaNovaBold.font(size: 23))
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
                        .font(R.font.proximaNovaBold.font(size: 35))
                        .foregroundColor(R.color.positiveButtonText.color)

                    R.image.chevron.image
                        .foregroundColor(R.color.positiveButtonText.color)
                }
            }
        }

        static func confirm(text: Text = R.string.localizable.confirm_button_title.text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    text
                        .font(R.font.proximaNovaBold.font(size: 35))
                        .foregroundColor(R.color.positiveButtonText.color)

                    R.image.chevron.image
                        .foregroundColor(R.color.positiveButtonText.color)
                }
            }
        }

        static func darkButton(text: Text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                text
                    .font(R.font.proximaNovaBold.font(size: 28))
                    .foregroundColor(R.color.darkButtonBorder.color)
                    .padding([.leading, .trailing], 12)
            }
            .frame(maxHeight: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(R.color.darkButtonBorder.color, lineWidth: 2)
            )
        }

        static func lightButton(text: Text, icon: Image? = R.image.chevron.image, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    text
                        .font(R.font.proximaNovaBold.font(size: 25))
                        .foregroundColor(R.color.lightButtonText.color)
                        .padding(.leading, 29)
                        .padding(.trailing, 8)

                    Spacer()

                    OptionalView(icon) { image in
                        image
                            .foregroundColor(R.color.lightButtonIcon.color)
                            .padding(.trailing, 27)
                    }
                }
            }
        }

        static func solidLightButton(text: Text, icon: Image? = R.image.chevron.image, action: @escaping () -> Void) -> some View {
            lightButton(text: text, action: action)
                .frame(height: 70)
                .background(R.color.lightButtonBackground.color)
                .cornerRadius(10)
                .shadow(color: R.color.shadow.color, radius: 4, x: 0, y: 4)
        }

        static func darkMainMenuButton(text: Text, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    text
                        .font(R.font.proximaNovaBold.font(size: 28))
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
                        .font(R.font.proximaNovaBold.font(size: 28))
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
                        .font(R.font.proximaNovaBold.font(size: 25))
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
}
