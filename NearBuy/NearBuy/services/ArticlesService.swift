//
//  ArticlesService.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import NexdClient
import RxSwift

class ArticlesService {
    static let shared = ArticlesService()

    func allArticles() -> Single<[Article]> {
        return ArticlesAPI.articlesControllerFindAll().asSingle()
    }
}
