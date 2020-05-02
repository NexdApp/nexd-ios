//
// BackendErrorResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct BackendErrorResponse: Codable { 


    public var statusCode: Int64
    public var errors: [BackendErrorEntry]

    public init(statusCode: Int64, errors: [BackendErrorEntry]) {
        self.statusCode = statusCode
        self.errors = errors
    }

}