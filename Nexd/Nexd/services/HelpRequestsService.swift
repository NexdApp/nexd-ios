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
    func submitRequest(dto: HelpRequestCreateDto) -> Single<HelpRequest> {
        return HelpRequestsAPI.helpRequestsControllerInsertRequestWithArticles(helpRequestCreateDto: dto)
            .asSingle()
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
