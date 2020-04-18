//
//  NexdUI+Player.swift
//  nexd
//
//  Created by Tobias Schröpf on 16.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

extension NexdUI {
    struct Player: View {
        @Binding var isPlaying: Bool
        @Binding var progress: Double

        var onPlayPause: (() -> Void)?
        var onProgressEdited: ((Double) -> Void)?

        var body: some View {
            HStack {
                Button(action: { self.onPlayPause?() },
                       label: { isPlaying ? R.image.pause.image : R.image.play.image })
                    .frame(width: 35, height: 35)
                    .foregroundColor(R.color.playerButton.color)

                Slider(value: $progress, in: 0.0 ... 1.0,
                       onEditingChanged: { isEditing in
                           guard !isEditing else { return }
                        self.onProgressEdited?(self.progress)
                })
                    .accentColor(.white)
            }
        }
    }
}

#if DEBUG
    struct Player_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                NexdUI.Player(isPlaying: Binding.constant(false),
                              progress: Binding.constant(0))
                .frame(width: 200, height: 100)
                .padding(20)
                .background(R.color.nexdGreen.color)
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
