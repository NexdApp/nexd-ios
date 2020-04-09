//
//  ViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SnapKit
import UIKit

class MainPageViewController: UIViewController {
    enum Style {
        static let profileImageSize = CGSize(width: 139, height: 139)
        static let padding: CGFloat = 25

        static let verticalPadding: CGFloat = 32
        static let horizontalPadding: CGFloat = 8
        static let buttonHeight: CGFloat = 132
    }

    private let mainContent = UIView()
    private let scrollView = UIScrollView()
    private let userProfileButton = UIButton()
    private let greetingText = UILabel()

    private let seekerButton = MenuButton.make(title: "Make a shopping list!")
    private let helperButton = MenuButton.make(title: "I can help!")

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.color.nexdGreen()
        navigationController?.navigationBar.isHidden = true

        view.addSubview(mainContent)
        mainContent.backgroundColor = R.color.defaultBackground()
        mainContent.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(115)
        }

        view.addSubview(userProfileButton)
        userProfileButton.backgroundColor = R.color.profileImageBackground()
        userProfileButton.layer.cornerRadius = 0.5 * Style.profileImageSize.width
        userProfileButton.setTitleColor(.white, for: .normal)
        userProfileButton.titleLabel?.font = R.font.proximaNovaSoftBold(size: 65)
        userProfileButton.setTitle("AJ", for: .normal)
        userProfileButton.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(mainContent.snp.top)
            make.size.equalTo(Style.profileImageSize)
        }
        userProfileButton.addTarget(self, action: #selector(profileButtonPressed(sender:)), for: .touchUpInside)

        mainContent.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(userProfileButton.snp.bottom).offset(27)
        }

        scrollView.addSubview(greetingText)
        greetingText.numberOfLines = 4
        greetingText.snp.makeConstraints { make in
            make.left.equalTo(mainContent).offset(Style.padding)
            make.right.equalTo(mainContent).offset(-Style.padding)
            make.top.equalToSuperview()
            make.height.equalTo(200)
        }
        greetingText.attributedText = "Welcome, Username.".asGreeting() + "\nWhat would you like to do today?".asGreetingSubline()

        scrollView.addSubview(seekerButton)
        seekerButton.snp.makeConstraints { make in
            make.left.equalTo(mainContent).offset(Style.horizontalPadding)
            make.right.equalTo(mainContent).offset(-Style.horizontalPadding)
            make.top.equalTo(greetingText.snp.bottom).offset(Style.verticalPadding)
            make.height.equalTo(132)
        }

        scrollView.addSubview(helperButton)
        helperButton.snp.makeConstraints { make in
            make.left.equalTo(mainContent).offset(Style.horizontalPadding)
            make.right.equalTo(mainContent).offset(-Style.horizontalPadding)
            make.top.equalTo(seekerButton.snp.bottom).offset(Style.verticalPadding)
            make.height.equalTo(132)
            make.bottom.equalToSuperview().offset(-Style.verticalPadding)
        }
    }
}

extension MainPageViewController {
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
