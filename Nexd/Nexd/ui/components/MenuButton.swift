//
//  MenuButton.swift
//  nexd
//
//  Created by Tobias Schröpf on 10.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class MenuButton: UIButton {
    enum Style {
        case light
        case dark

        var borderColor: UIColor? {
            switch self {
            case .light:
                return R.color.nexdGreen()

            case .dark:
                return R.color.darkButtonBorder()
            }
        }

        var textColor: UIColor? {
            switch self {
            case .light:
                return R.color.nexdGreen()

            case .dark:
                return R.color.darkButtonText()
            }
        }

    }

    private var image: UIImage? {
        didSet {
            setImage(image, for: .normal)
        }
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        guard let image = image else { return .zero }

        return CGRect(x: contentRect.maxX - image.size.width - 17,
                      y: contentRect.minY + (contentRect.height - image.size.height) / 2,
                      width: image.size.width,
                      height: image.size.height)
    }

    static func make(style: Style) -> MenuButton {
        let button = MenuButton()

        button.backgroundColor = .clear
        button.addBorder(color: style.borderColor)

        button.titleLabel?.numberOfLines = 2
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        button.image = R.image.chevron()?.withTintColor(style.borderColor!)

        return button
    }
}
