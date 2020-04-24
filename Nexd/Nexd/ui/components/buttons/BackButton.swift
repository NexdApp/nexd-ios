//
//  BackButton.swift
//  nexd
//
//  Created by Tobias Schröpf on 10.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class BackButton: UIButton {
    private var image: UIImage? {
        didSet {
            setImage(image, for: .normal)
        }
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        guard let image = image else { return .zero }

        return CGRect(x: contentRect.minX,
                      y: contentRect.minY + (contentRect.height - image.size.height) / 2,
                      width: image.size.width,
                      height: image.size.height)
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageWidth: CGFloat = image?.size.width ?? 0
        let padding: CGFloat = imageWidth > 0 ? 10 : 0
        return CGRect(x: contentRect.minX + imageWidth + padding,
                      y: contentRect.minY,
                      width: contentRect.size.width - imageWidth - padding,
                      height: contentRect.size.height)
    }

    static func make(tintColor: UIColor = R.color.darkButtonText()!) -> BackButton {
        let button = BackButton()

        button.backgroundColor = .clear
        button.titleLabel?.numberOfLines = 1
        button.contentHorizontalAlignment = .left

        button.image = R.image.chevron_left()?.withTintColor(tintColor)

        return button
    }
}
