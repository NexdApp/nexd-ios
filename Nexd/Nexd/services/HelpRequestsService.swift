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

class HelpRequestsService {
    struct Request {
        public var firstName: String?
        public var lastName: String?
        public var street: String?
        public var number: String?
        public var zipCode: String?
        public var city: String?
        public var items: [RequestItem]?
        public var additionalRequest: String?
        public var deliveryComment: String?
        public var phoneNumber: String?

        var dto: HelpRequestCreateDto {
            HelpRequestCreateDto(firstName: firstName,
                                 lastName: lastName,
                                 street: street,
                                 number: number,
                                 zipCode: zipCode,
                                 city: city,
                                 articles: items?.map { CreateHelpRequestArticleDto(articleId: $0.itemId,
                                                                                    articleName: nil,
                                                                                    language: nil,
                                                                                    articleCount: $0.articleCount,
                                                                                    unitId: nil) },
                                 status: .pending,
                                 additionalRequest: additionalRequest, deliveryComment: deliveryComment, phoneNumber: phoneNumber)
        }
    }

    struct RequestItem {
        let itemId: Int64
        let articleCount: Int64
    }

    func submitRequest(request: Request) -> Single<HelpRequest> {
        return HelpRequestsAPI.helpRequestsControllerInsertRequestWithArticles(helpRequestCreateDto: request.dto).asSingle()
    }

    func openRequests(userId: String? = nil,
                      excludeUserId: Bool? = nil,
                      zipCode: [String]? = nil,
                      includeRequester: Bool = true,
                      status: [HelpRequestStatus]? = nil) -> Single<[HelpRequest]> {
        return HelpRequestsAPI.helpRequestsControllerGetAll(userId: userId,
                                                            excludeUserId: excludeUserId,
                                                            zipCode: zipCode,
                                                            includeRequester: includeRequester,
                                                            status: status)
            .asSingle()
    }

    func fetchRequest(requestId: Int64) -> Single<HelpRequest> {
        return HelpRequestsAPI.helpRequestsControllerGetSingleRequest(helpRequestId: requestId)
            .asSingle()
    }
}
