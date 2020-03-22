//
// RequestFormDto.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct RequestFormDto: Codable {

    public var street: String?
    public var number: String?
    public var zipCode: String
    public var city: String
    /** List of articles */
    public var articles: [CreateRequestArticleDto]
    public var additionalRequest: String
    public var deliveryComment: String
    public var phoneNumber: String

    public init(street: String?, number: String?, zipCode: String, city: String, articles: [CreateRequestArticleDto], additionalRequest: String, deliveryComment: String, phoneNumber: String) {
        self.street = street
        self.number = number
        self.zipCode = zipCode
        self.city = city
        self.articles = articles
        self.additionalRequest = additionalRequest
        self.deliveryComment = deliveryComment
        self.phoneNumber = phoneNumber
    }


}

