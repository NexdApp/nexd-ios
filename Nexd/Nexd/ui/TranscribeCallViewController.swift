//
//  RequestDetailsViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 04.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit

class TranscribeCallViewController: UIViewController {
    private var disposeBag: DisposeBag?

    private var gradient = GradientView()
    private var titleLabel = UILabel()

    private var playPauseButton = UIButton()
    private var slider = UISlider()

    private var player: AudioPlayer?

    var callSid: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = R.string.localizable.helper_request_detail_screen_title()

        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        playPauseButton.addTarget(self, action: #selector(playPauseButtonPressed(sender:)), for: .touchUpInside)
        playPauseButton.setImage(R.image.round_play_arrow_black_36pt(), for: .normal)
        playPauseButton.setImage(R.image.round_pause_black_36pt(), for: .selected)
        playPauseButton.tintColor = .buttonTextColor

        view.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.left.equalToSuperview().offset(18)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }

        slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        view.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.centerY.equalTo(playPauseButton)
            make.left.equalTo(playPauseButton.snp.right).offset(20)
            make.right.equalToSuperview().offset(-40)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let disposeBag = DisposeBag()

        guard let sid = callSid else { return }

        CallsService.shared.callFileUrl(sid: sid)
            .asObservable()
            .flatMap { url -> Observable<AudioPlayer.PlayerState> in
                let audioPlayer = AudioPlayer(url: url)
                guard let player = audioPlayer else {
                    return Observable.never()
                }

                return player.state
            }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] state in
                self?.slider.setValue(state.progress, animated: state.progress != 0)
                self?.playPauseButton.isSelected = state.isPlaying
            })
            .disposed(by: disposeBag)

        self.disposeBag = disposeBag
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        player?.stop()
        disposeBag = nil
    }
}

extension TranscribeCallViewController {
    @objc func playPauseButtonPressed(sender: UIButton!) {
        if playPauseButton.isSelected {
            player?.pause()
        } else {
            player?.play()
        }
    }

    @objc func sliderValueChanged(sender: UISlider) {
        player?.seekTo(progress: sender.value)
    }
}
