//
//  RequestService.swift
//  Nexd
//
//  Created by Tobias Schröpf on 22.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import RxSwift
import NexdClient

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
                                 zipCode: nil,
                                 city: nil,
                                 articles: articles,
                                 status: .pending,
                                 additionalRequest: "",
                                 deliveryComment: "",
                                 phoneNumber: "")
        return RequestAPI.requestControllerInsertRequestWithArticles(requestFormDto: dto).asSingle()
    }

    func openRequests(onlyMine: Bool = false) -> Single<[RequestEntity]> {
        guard !onlyMine else {
            return RequestAPI.requestControllerGetAll(onlyMine: "true").asSingle()
        }

        return RequestAPI.requestControllerGetAll().asSingle()
    }

    func fetchRequest(id: Int) -> Single<RequestEntity> {
        return RequestAPI.requestControllerGetSingleRequest(requestId: id)
            .asSingle()
    }
}
