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

        view.addSubview(seekerTitle)
        seekerTitle.styleDefault()
        seekerTitle.attributedText = R.string.localizable.role_selection_seeker().asAttributedDefault()
        seekerTitle.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(Style.padding)
        }

        view.addSubview(seekerRoleButton)
        seekerRoleButton.backgroundColor = Style.buttonBackgroundColor
        seekerRoleButton.layer.cornerRadius = 0.5 * Style.buttonSize.width
        seekerRoleButton.addShadow()
        seekerRoleButton.tintColor = .black
        seekerRoleButton.setImage(R.image.outline_shopping_cart_black_48pt(), for: .normal)
        seekerRoleButton.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.size.equalTo(Style.buttonSize)
            make.top.equalTo(seekerTitle.snp.bottom).offset(16)
        }
        seekerRoleButton.addTarget(self, action: #selector(seekerRoleButtonPressed(sender:)), for: .touchUpInside)

        view.addSubview(helperTitle)
        helperTitle.styleDefault()
        helperTitle.attributedText = R.string.localizable.role_selection_helper().asAttributedDefault()
        helperTitle.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.bottomMargin.equalTo(-Style.padding)
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
            make.bottom.equalTo(helperTitle.snp.top).offset(-16)
        }
        helperRoleButton.addTarget(self, action: #selector(helperRoleButtonPressed(sender:)), for: .touchUpInside)

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

    @objc func seekerRoleButtonPressed(sender: UIButton!) {
        navigationController?.pushViewController(SeekerItemSelectionViewController(), animated: true)
    }
}
