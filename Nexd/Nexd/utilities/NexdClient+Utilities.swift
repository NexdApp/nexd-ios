//
//  Article+Identifiable.swift
//  nexd
//
//  Created by Tobias Schröpf on 28.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient

extension Article: Identifiable, Hashable, Equatable, Comparable {
    public static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }

    public static func < (lhs: Article, rhs: Article) -> Bool {
        return lhs.name < rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension NexdClient.Unit: Identifiable {
    func displayString(for amount: Int64?) -> String {
        switch amount {
        case 0, nil:
            return nameZero

        case 1:
            return nameOne

        case 2:
            return nameTwo

        default:
            return nameMany
        }
    }
}

extension HelpRequestArticle: Identifiable {
    public var id: Int64? {
        articleId
    }
}

extension AvailableLanguages {
    static var current: AvailableLanguages {
        let currentLanguages = Bundle.main.preferredLocalizations
            .compactMap { AvailableLanguages(rawValue: $0) }

        return currentLanguages.first ?? .en
    }
}

extension CreateHelpRequestArticleDto.Language {
    static var current: CreateHelpRequestArticleDto.Language {
        let currentLanguages = Bundle.main.preferredLocalizations
            .compactMap { CreateHelpRequestArticleDto.Language(rawValue: $0) }

        return currentLanguages.first ?? .en
    }
}

extension HelpRequest {
    var displayAddress: String? {
        if street == nil, number == nil, zipCode == nil, city == nil {
            return nil
        }

        return """
        \(street ?? "") \(number ?? "")
        \(zipCode ?? "") \(city ?? "")
        """
    }
}
