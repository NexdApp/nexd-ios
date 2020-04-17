//
//  AudioPlayer.swift
//  Nexd
//
//  Created by Tobias Schröpf on 04.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import AVFoundation
import Foundation
import RxRelay
import RxSwift

class AudioPlayer: NSObject {
    struct PlayerState {
        let isPlaying: Bool
        let currentTime: TimeInterval
        let duration: TimeInterval
        var progress: Float { Float(currentTime / duration) }

        fileprivate static func from(player: AVAudioPlayer) -> PlayerState {
            return PlayerState(isPlaying: player.isPlaying,
                               currentTime: player.currentTime,
                               duration: player.duration)
        }
    }

    private let player: AVAudioPlayer?

    fileprivate let isPlaying = BehaviorRelay<Bool>(value: false)

    var state: Observable<PlayerState> {
        return isPlaying
            .flatMapLatest { [weak self] isPlaying -> Observable<PlayerState> in
                guard let player = self?.player else {
                    return Observable.empty()
                }

                guard isPlaying else {
                    return Observable.just(PlayerState.from(player: player))
                }

                return Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
                    .map { _ in PlayerState.from(player: player) }
            }
    }

    init(url: URL) {
        player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

        super.init()
        player?.delegate = self
    }

    init?(data: Data, fileTypeHint: String?) {
        player = try? AVAudioPlayer(data: data, fileTypeHint: fileTypeHint)

        super.init()
        player?.delegate = self
    }

    func seekTo(time: TimeInterval) {
        player?.currentTime = time
    }

    func seekTo(progress: Float) {
        guard let player = player else { return }

        player.currentTime = TimeInterval(progress * Float(player.duration))
    }

    func play() {
        guard let player = player else { return }

        if !player.isPlaying {
            player.play()
        }

        isPlaying.accept(true)
    }

    func pause() {
        guard let player = player else { return }

        player.pause()
        isPlaying.accept(false)
    }

    func stop() {
        guard let player = player else { return }

        player.stop()
        player.currentTime = 0
        isPlaying.accept(false)
    }

    static func sampleWav() -> AudioPlayer {
        let path = Bundle.main.path(forResource: "cymbal.wav", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        return AudioPlayer(url: url)
    }

    static func sampleMp3() -> AudioPlayer {
        let path = Bundle.main.path(forResource: "recording.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        return AudioPlayer(url: url)
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying.accept(false)
    }
}
