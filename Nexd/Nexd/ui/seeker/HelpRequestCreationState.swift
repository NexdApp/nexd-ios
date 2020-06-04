//
//  ItemSelectionViewState.swift
//  nexd
//
//  Created by Tobias Schröpf on 29.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient

class HelpRequestCreationState: ObservableObject {
    struct Item: Identifiable {
        let id = UUID()

        let article: Article?
        let name: String
        let amount: Int64
        let unit: Unit?

        var dto: CreateHelpRequestArticleDto {
            guard let article = article else {
                return CreateHelpRequestArticleDto(articleId: nil,
                                                   articleName: name,
                                                   language: CreateHelpRequestArticleDto.Language.current,
                                                   articleCount: amount,
                                                   unitId: unit?.id)
            }

            return CreateHelpRequestArticleDto(articleId: article.id,
                                               articleName: nil,
                                               language: nil,
                                               articleCount: amount,
                                               unitId: unit?.id)
        }
    }

    let language: AvailableLanguages = .current

    @Published var items: [Item] = []
    @Published var units: [Unit]?

    @Published var firstName: String?
    @Published var lastName: String?
    @Published var street: String?
    @Published var houseNumber: String?
    @Published var zipCode: String?
    @Published var city: String?
    @Published var phoneNumber: String?
    @Published var information: String?
    @Published var deliveryComment: String?

    var dto: HelpRequestCreateDto {
        let articleDtos = items
            .filter { $0.amount > 0 }
            .map { $0.dto }

        return HelpRequestCreateDto(firstName: firstName,
                                    lastName: lastName,
                                    street: street,
                                    number: houseNumber,
                                    zipCode: zipCode,
                                    city: city,
                                    articles: articleDtos,
                                    status: nil,
                                    additionalRequest: information,
                                    deliveryComment: deliveryComment,
                                    phoneNumber: phoneNumber)
    }
}
