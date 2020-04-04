//
//  RequestDetailsViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 04.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit
import SnapKit

class RequestDetailsViewController: UIViewController {
    private var gradient = GradientView()
    private var titleLabel = UILabel()

    private var playPauseButton = UIButton()
    private var slider = UISlider()

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
            make.left.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }

        view.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.centerY.equalTo(playPauseButton)
            make.left.equalTo(playPauseButton.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
        }
    }
}

extension RequestDetailsViewController {
    @objc func playPauseButtonPressed(sender: UIButton!) {
        sender.isSelected = !sender.isSelected
    }
}
