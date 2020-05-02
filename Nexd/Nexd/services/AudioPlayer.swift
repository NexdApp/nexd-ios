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
        let currentTime: CMTime?
        let duration: CMTime?
        var progress: Double? {
            guard let currentTime = currentTime, let duration = duration else {
                return nil
            }
            return currentTime.seconds / duration.seconds
        }

        fileprivate static func from(player: AVPlayer) -> PlayerState {
            return PlayerState(isPlaying: player.timeControlStatus == .playing,
                               currentTime: player.currentTime(),
                               duration: player.currentItem?.duration)
        }
    }

    private let player: AVPlayer?

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
        player = AVPlayer(url: url)

        super.init()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPlayToEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func seekTo(progress: Float) {
        guard let currentItem = player?.currentItem else { return }

        let time = CMTime(value: CMTimeValue(Double(progress) * currentItem.duration.seconds * 60000.0), timescale: 60000)
        player?.seek(to: time)
    }

    func play() {
        guard let player = player else { return }

        try? AVAudioSession.sharedInstance().setActive(true)

        player.play()

        isPlaying.accept(true)
    }

    func pause() {
        guard let player = player else { return }

        player.pause()
        isPlaying.accept(false)

        try? AVAudioSession.sharedInstance().setActive(false)
    }

    func stop() {
        guard let player = player else { return }

        player.pause()
        player.seek(to: .zero)
        isPlaying.accept(false)

        try? AVAudioSession.sharedInstance().setActive(false)
    }

    @objc
    private func didPlayToEnd(notification: Notification) {
        guard let item = notification.object as? AVPlayerItem, item == player?.currentItem else { return }
        stop()
    }
}
