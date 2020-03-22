//
//  RequestService.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 22.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import SwaggerClient
import RxSwift

class RequestService {
    struct RequestItem {
        let id: Int
        let articleCount: Int
    }

    static let shared = RequestService()

    func submitRequest(items: [RequestItem]) -> Single<RequestEntity> {
        let articles = items.map { CreateRequestArticleDto(articleId: $0.id, articleCount: $0.articleCount) }

        let dto = RequestFormDto(street: nil,
                                 number: nil,
                                 zipCode: "12345",
                                 city: "München",
                                 articles: articles,
                                 additionalRequest: "",
                                 deliveryComment: "",
                                 phoneNumber: "")
        return RequestAPI.requestControllerInsertRequestWithArticles(body: dto).asSingle()
    }

    func openRequests(onlyMine: Bool = false) -> Single<[RequestEntity]> {
        guard !onlyMine else {
            return RequestAPI.requestControllerGetAll(onlyMine: "true").asSingle()
        }

        return RequestAPI.requestControllerGetAll().asSingle()
    }
}
