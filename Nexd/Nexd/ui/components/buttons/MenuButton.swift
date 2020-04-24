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
        case solid

        var borderColor: UIColor? {
            switch self {
            case .light:
                return R.color.nexdGreen()

            case .dark:
                return R.color.darkButtonBorder()

            case .solid:
                return nil
            }
        }

        var textColor: UIColor? {
            switch self {
            case .light:
                return R.color.nexdGreen()

            case .dark:
                return R.color.darkButtonText()

            case .solid:
                return R.color.solidButtonText()
            }
        }

        var backgroundColor: UIColor? {
            switch self {
            case .light:
                return .clear

            case .dark:
                return .clear

            case .solid:
                return R.color.solidButtonBackground()
            }
        }

        var chevronColor: UIColor? {
            switch self {
            case .light:
                return R.color.nexdGreen()

            case .dark:
                return R.color.darkButtonBorder()

            case .solid:
                return R.color.solidButtonIcon()
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

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageWidth: CGFloat = image?.size.width ?? 0
        let padding: CGFloat = imageWidth > 0 ? 8 : 0
        return CGRect(x: contentRect.minX,
                      y: contentRect.minY,
                      width: contentRect.size.width - imageWidth - 17 - padding,
                      height: contentRect.size.height)
    }

    static func make(style: Style) -> MenuButton {
        let button = MenuButton()

        button.backgroundColor = style.backgroundColor
        if let borderColor = style.borderColor {
            button.addBorder(color: borderColor)
        } else {
            button.layer.cornerRadius = 10
        }

        button.titleLabel?.numberOfLines = 2
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 10)

        button.image = R.image.chevron()?.withTintColor(style.chevronColor!)

        return button
    }
}
