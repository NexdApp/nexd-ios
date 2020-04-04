//
//  UserProfileViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 03.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit

class UserProfileViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private lazy var logoutButton = UIButton()
    private lazy var titleLabel = UILabel()

    var onUserLoggedOut: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(titleLabel)
        titleLabel.styleHeader()
        titleLabel.attributedText = R.string.localizable.user_profile_screen_title().asTitle()
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Style.verticalPadding)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }

        view.addSubview(logoutButton)
        logoutButton.style(text: R.string.localizable.user_profile_button_title_logout())
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed(sender:)), for: .touchUpInside)
        logoutButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-Style.verticalPadding)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadProfile()
    }

    private func loadProfile() {
        guard let userId = Storage.shared.userId else {
            log.error("No userID is available!")
            return
        }

        UserService.shared.fetchUserInfo(usreId: userId)
            .subscribe(onSuccess: { user in
                log.debug("User: \(user)")
            }, onError: { error in
                log.error("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

extension UserProfileViewController {
    @objc func logoutButtonPressed(sender: UIButton) {
        AuthenticationService.shared.logout()
        onUserLoggedOut?()
    }
}
