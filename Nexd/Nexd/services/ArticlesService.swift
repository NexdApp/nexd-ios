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
    func allArticles() -> Single<[Article]> {
        return ArticlesAPI.articlesControllerFindAll().asSingle()
    }
}
