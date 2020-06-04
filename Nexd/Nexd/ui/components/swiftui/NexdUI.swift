//
//  NexdUI.swift
//  nexd
//
//  Created by Tobias Schröpf on 13.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Rswift
import SwiftUI

/// Base type which used to gropu all nexd specific ui components in one namespace
enum NexdUI {}

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
