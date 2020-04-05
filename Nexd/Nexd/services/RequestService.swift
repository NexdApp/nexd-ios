//
//  RequestService.swift
//  Nexd
//
//  Created by Tobias Schröpf on 22.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import NexdClient
import RxSwift

class RequestService {
    struct RequestItem {
        let itemId: Int
        let articleCount: Int
    }

    static let shared = RequestService()

    func submitRequest(items: [RequestItem]) -> Single<HelpRequest> {
        let articles = items.map { CreateHelpRequestArticleDto(articleId: $0.itemId, articleCount: $0.articleCount) }

        let dto = HelpRequestCreateDto(street: nil,
                                       number: nil,
                                       zipCode: nil,
                                       city: nil,
                                       articles: articles,
                                       status: .pending,
                                       additionalRequest: nil,
                                       deliveryComment: nil,
                                       phoneNumber: nil)
        return HelpRequestsAPI.helpRequestsControllerInsertRequestWithArticles(helpRequestCreateDto: dto).asSingle()
    }

    func openRequests(userId: String? = nil, zipCode: [String]? = nil, includeRequester: Bool = false, status: [String]? = nil) -> Single<[HelpRequest]> {
        return HelpRequestsAPI.helpRequestsControllerGetAll(userId: userId,
                                                            zipCode: zipCode,
                                                            includeRequester: includeRequester ? "true" : nil,
                                                            status: status)
            .asSingle()
    }

    func fetchRequest(requestId: Int) -> Single<HelpRequest> {
        return HelpRequestsAPI.helpRequestsControllerGetSingleRequest(helpRequestId: requestId)
            .asSingle()
    }
}
