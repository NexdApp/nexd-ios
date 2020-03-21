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

    lazy var buyerRoleButton = UIButton()
    lazy var affectedRoleButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = R.string.localizable.role_selection_screen_title()

        view.addSubview(buyerRoleButton)
        buyerRoleButton.backgroundColor = Style.buttonBackgroundColor
        buyerRoleButton.setTitle(R.string.localizable.role_selection_buyer(), for: .normal)
        buyerRoleButton.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.topMargin.equalTo(50)
        }
        buyerRoleButton.addTarget(self, action: #selector(buyerRoleButtonPressed(sender:)), for: .touchUpInside)

        view.addSubview(affectedRoleButton)
        affectedRoleButton.backgroundColor = Style.buttonBackgroundColor
        affectedRoleButton.setTitle(R.string.localizable.role_selection_seeker(), for: .normal)
        affectedRoleButton.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(buyerRoleButton.snp_bottom).offset(16)
        }
        affectedRoleButton.addTarget(self, action: #selector(affectedRoleButtonPressed(sender:)), for: .touchUpInside)
    }
}

extension SelectRoleViewController {
    @objc func buyerRoleButtonPressed(sender: UIButton!) {
        self.navigationController?.pushViewController(BuyerRequestOverviewViewController(), animated: true)
    }

    @objc func affectedRoleButtonPressed(sender: UIButton!) {
        log.debug("Affected role selected")
    }
}

