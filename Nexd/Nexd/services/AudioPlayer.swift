//
//  AudioPlayer.swift
//  Nexd
//
//  Created by Tobias Schröpf on 04.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import AVFoundation
import Foundation

class AudioPlayer: NSObject {
    static let sahred = AudioPlayer()

    var player: AVAudioPlayer?

    func playSamle() {
        let path = Bundle.main.path(forResource: "cymbal.wav", ofType: nil)!
        let url = URL(fileURLWithPath: path)

        play(url: url)
    }

    func play(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.play()
        } catch {
            log.error("Could not play: ")
        }
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    
}
