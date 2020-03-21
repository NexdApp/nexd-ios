//
//  ViewController.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SnapKit
import UIKit

class SelectRoleViewController: UIViewController {
    enum Style {
        static let buttonBackgroundColor: UIColor = .gray
    }

    lazy var helperRoleButton = UIButton()
    lazy var affectedRoleButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = R.string.localizable.role_selection_screen_title()

        view.addSubview(helperRoleButton)
        helperRoleButton.backgroundColor = Style.buttonBackgroundColor
        helperRoleButton.setTitle(R.string.localizable.role_selection_helper(), for: .normal)
        helperRoleButton.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.topMargin.equalTo(50)
        }
        helperRoleButton.addTarget(self, action: #selector(helperRoleButtonPressed(sender:)), for: .touchUpInside)

        view.addSubview(affectedRoleButton)
        affectedRoleButton.backgroundColor = Style.buttonBackgroundColor
        affectedRoleButton.setTitle(R.string.localizable.role_selection_seeker(), for: .normal)
        affectedRoleButton.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(helperRoleButton.snp_bottom).offset(16)
        }
        affectedRoleButton.addTarget(self, action: #selector(affectedRoleButtonPressed(sender:)), for: .touchUpInside)
    }
}

extension SelectRoleViewController {
    @objc func helperRoleButtonPressed(sender: UIButton!) {
        self.navigationController?.pushViewController(HelperRequestOverviewViewController(), animated: true)
    }

    @objc func affectedRoleButtonPressed(sender: UIButton!) {
        log.debug("Affected role selected")
    }
}

