//
// CallQueryDto.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct CallQueryDto: Codable { 


    public var amount: Int?
    public var country: String?
    public var zip: String?
    public var city: String?
    public var converted: Bool?

    public init(amount: Int?, country: String?, zip: String?, city: String?, converted: Bool?) {
        self.amount = amount
        self.country = country
        self.zip = zip
        self.city = city
        self.converted = converted
    }

}