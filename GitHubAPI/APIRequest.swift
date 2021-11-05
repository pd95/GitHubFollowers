//
//  APIRequest.swift
//  GitHubAPI
//
//  Created by Philipp on 02.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

public protocol APIRequest {
    associatedtype RequestDataType
    associatedtype ResponseDataType

    func makeRequest(from data: RequestDataType) throws -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
}
