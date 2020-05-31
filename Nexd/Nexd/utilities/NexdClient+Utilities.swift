//
//  Article+Identifiable.swift
//  nexd
//
//  Created by Tobias Schröpf on 28.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient

extension Article: Identifiable {}

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
