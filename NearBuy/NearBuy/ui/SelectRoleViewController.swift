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
    lazy var seekerRoleButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = R.string.localizable.role_selection_screen_title()

        view.addSubview(helperRoleButton)
        helperRoleButton.backgroundColor = Style.buttonBackgroundColor
        helperRoleButton.setTitle(R.string.localizable.role_selection_helper(), for: .normal)
        helperRoleButton.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.topMargin.equalTo(50)
        }
        helperRoleButton.addTarget(self, action: #selector(helperRoleButtonPressed(sender:)), for: .touchUpInside)

        view.addSubview(seekerRoleButton)
        seekerRoleButton.backgroundColor = Style.buttonBackgroundColor
        seekerRoleButton.setTitle(R.string.localizable.role_selection_seeker(), for: .normal)
        seekerRoleButton.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(helperRoleButton.snp_bottom).offset(16)
        }
        seekerRoleButton.addTarget(self, action: #selector(seekerRoleButtonPressed(sender:)), for: .touchUpInside)
    }
}

extension SelectRoleViewController {
    @objc func helperRoleButtonPressed(sender: UIButton!) {
        navigationController?.pushViewController(HelperRequestOverviewViewController(), animated: true)
    }

    @objc func seekerRoleButtonPressed(sender: UIButton!) {
        navigationController?.pushViewController(SeekerItemSelectionViewController(), animated: true)
    }
}
