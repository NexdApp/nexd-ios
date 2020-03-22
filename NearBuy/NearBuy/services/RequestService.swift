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

    func submitRequest(items: [RequestItem]) -> Single<Request> {
        let articles = items.map { CreateRequestArticleDto(articleId: $0.id, articleCount: $0.articleCount) }

        let dto = CreateRequestDto(articles: articles,
                                   address: "",
                                   zipCode: "",
                                   city: "",
                                   additionalRequest: "",
                                   deliveryComment: "",
                                   phoneNumber: "")
        return RequestAPI.requestControllerInsertRequestWithArticles(body: dto).asSingle()
    }
}
