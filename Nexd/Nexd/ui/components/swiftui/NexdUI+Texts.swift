//
//  NexdUI+Texts.swift
//  nexd
//
//  Created by Tobias Schröpf on 04.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

extension NexdUI {
    enum Texts {
        static func title(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaBold.font(size: 35))
                .foregroundColor(R.color.headingText.color)
        }

        static func h2Dark(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaBold.font(size: 25))
                .foregroundColor(R.color.darkHeadingText.color)
        }

        static func defaultDark(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaBold.font(size: 16))
                .foregroundColor(R.color.darkHeadingText.color)
        }

        static func detailsText(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaBold.font(size: 20))
                .foregroundColor(R.color.darkHeadingText.color)
        }

        static func sectionHeader(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaBold.font(size: 25))
                .foregroundColor(R.color.headingText.color)
        }

        static func cardSectionHeader(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaBold.font(size: 18))
                .foregroundColor(R.color.darkListItemTitle.color)
        }

        static func cardText(text: Text) -> some View {
            text
                .font(R.font.proximaNovaBold.font(size: 18))
                .foregroundColor(R.color.listItemTitle.color)
        }

        static func cardPlaceholderText(text: Text) -> some View {
            text
                .font(R.font.proximaNovaBold.font(size: 14))
                .foregroundColor(R.color.listItemDetailsText.color)
        }

        static func filterButtonDetailsText(text: Text) -> some View {
            text
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(R.font.proximaNovaRegular.font(size: 14))
                .foregroundColor(R.color.filterButtonDetails.color)
        }

        static func suggestion(text: String, highlight: String?) -> some View {
            guard let highlight = highlight, let highlightRange = text.range(of: highlight, options: .caseInsensitive), !highlightRange.isEmpty else {
                return Text(text).notMatchingText()
            }

            let prefix = text[..<highlightRange.lowerBound]
            let match = text[highlightRange.lowerBound ..< highlightRange.upperBound]
            let suffix = text[highlightRange.upperBound ..< text.endIndex]

            return Text(prefix).notMatchingText()
                + Text(match).matchingText()
                + Text(suffix).notMatchingText()
        }

        static func matching(_ text: String) -> Text {
            Text(text).matchingText()
        }

        static func notMatching(_ text: String) -> Text {
            Text(text).notMatchingText()
        }
    }
}

extension Text {
    fileprivate func matchingText() -> Text {
        font(R.font.proximaNovaBold.font(size: 16))
            .foregroundColor(R.color.matchingText.color)
    }

    fileprivate func notMatchingText() -> Text {
        font(R.font.proximaNovaRegular.font(size: 16))
            .foregroundColor(R.color.notMatchingText.color)
    }
}
