//
//  ViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SnapKit
import UIKit

class SelectRoleViewController: UIViewController {
    enum Style {
        static let buttonBackgroundColor: UIColor = .white
        static let buttonSize = CGSize(width: 100, height: 100)
        static let padding = 64
    }

    lazy var gradient = GradientView()
    lazy var seekerTitle = UILabel()
    lazy var seekerRoleButton = UIButton()
    lazy var transcriberRoleButton = UIButton()
    lazy var helperRoleButton = UIButton()
    lazy var helperTitle = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = R.string.localizable.role_selection_screen_title()

        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(transcriberRoleButton)
        transcriberRoleButton.backgroundColor = Style.buttonBackgroundColor
        transcriberRoleButton.layer.cornerRadius = 0.5 * Style.buttonSize.width
        transcriberRoleButton.addShadow()
        transcriberRoleButton.tintColor = .black
        transcriberRoleButton.setImage(R.image.baseline_voicemail_black_48pt(), for: .normal)
        transcriberRoleButton.snp.makeConstraints { make -> Void in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(Style.buttonSize)
        }
        transcriberRoleButton.addTarget(self, action: #selector(transcriberRoleButtonPressed(sender:)), for: .touchUpInside)

        view.addSubview(seekerRoleButton)
        seekerRoleButton.backgroundColor = Style.buttonBackgroundColor
        seekerRoleButton.layer.cornerRadius = 0.5 * Style.buttonSize.width
        seekerRoleButton.addShadow()
        seekerRoleButton.tintColor = .black
        seekerRoleButton.setImage(R.image.outline_shopping_cart_black_48pt(), for: .normal)
        seekerRoleButton.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.size.equalTo(Style.buttonSize)
            make.bottom.equalTo(transcriberRoleButton.snp.top).offset(-84)
        }
        seekerRoleButton.addTarget(self, action: #selector(seekerRoleButtonPressed(sender:)), for: .touchUpInside)

        view.addSubview(seekerTitle)
        seekerTitle.styleDefault()
        seekerTitle.attributedText = R.string.localizable.role_selection_seeker().asDefaultText()
        seekerTitle.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(seekerRoleButton.snp.top).offset(-16)
        }

        view.addSubview(helperRoleButton)
        helperRoleButton.backgroundColor = Style.buttonBackgroundColor
        helperRoleButton.layer.cornerRadius = 0.5 * Style.buttonSize.width
        helperRoleButton.addShadow()
        helperRoleButton.tintColor = .black
        helperRoleButton.setImage(R.image.outline_directions_walk_black_48pt(), for: .normal)
        helperRoleButton.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.size.equalTo(Style.buttonSize)
            make.top.equalTo(transcriberRoleButton.snp.bottom).offset(84)
        }
        helperRoleButton.addTarget(self, action: #selector(helperRoleButtonPressed(sender:)), for: .touchUpInside)

        view.addSubview(helperTitle)
        helperTitle.styleDefault()
        helperTitle.attributedText = R.string.localizable.role_selection_helper().asDefaultText()
        helperTitle.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(helperRoleButton.snp.bottom).offset(16)
        }

        let profileButton = UIBarButtonItem(image: R.image.baseline_account_box_black_24pt(),
                                            style: .plain,
                                            target: self,
                                            action: #selector(profileButtonPressed(sender:)))
        profileButton.tintColor = .label
        navigationItem.rightBarButtonItem = profileButton
    }
}

extension SelectRoleViewController {
    @objc func profileButtonPressed(sender: UIBarButtonItem!) {
        let profileScreen = UserProfileViewController()
        profileScreen.onUserLoggedOut = { [weak self] in
            log.debug("User logged out!")
            self?.dismiss(animated: true) { [weak self] in
                self?.navigationController?.setViewControllers([LoginViewController()], animated: true)
            }
        }
        present(profileScreen, animated: true, completion: nil)
    }

    @objc func helperRoleButtonPressed(sender: UIButton!) {
        navigationController?.pushViewController(HelperRequestOverviewViewController(), animated: true)
    }

    @objc func transcriberRoleButtonPressed(sender: UIButton!) {
        navigationController?.pushViewController(CallsListViewController(), animated: true)
    }

    @objc func seekerRoleButtonPressed(sender: UIButton!) {
        navigationController?.pushViewController(SeekerItemSelectionViewController(), animated: true)
    }
}
