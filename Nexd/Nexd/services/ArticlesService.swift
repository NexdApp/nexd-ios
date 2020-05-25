//
//  ArticlesService.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import NexdClient
import RxSwift

class ArticlesService {
    func allArticles(limit: Double? = nil, startsWith: String? = nil, language: AvailableLanguages? = nil, onlyVerified: Bool? = nil) -> Single<[Article]> {
        return ArticlesAPI.articlesControllerFindAll(limit: limit, startsWith: startsWith, language: language, onlyVerified: onlyVerified)
            .asSingle()
    }

    func allUnits(language: AvailableLanguages? = nil) -> Single<[NexdClient.Unit]> {
        return ArticlesAPI.articlesControllerGetUnits(language: language)
            .asSingle()
    }
}
