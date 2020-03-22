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
    static let shared = RequestService()

    func submitRequest() -> Single<Request> {
        let articles = [CreateRequestArticleDto(articleId: 1, articleCount: 1)]

        let dto = CreateRequestDto(articles: articles,
                                   address: "test",
                                   zipCode: "hallo",
                                   city: "stadt",
                                   additionalRequest: "nix",
                                   deliveryComment: "dahoam",
                                   phoneNumber: "123456")
        return RequestAPI.requestControllerInsertRequestWithArticles(body: dto).asSingle()
    }
}
