//
//  UserInfoRequest.swift
//  GitHubAPI
//
//  Created by Philipp on 02.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

public struct UserInfoRequest: APIRequest {
    public typealias RequestDataType = Parameter
    public typealias ResponseDataType = GHUser

    public struct Parameter {
        let username: String
        var baseURL: URL

        public init(username: String, baseURL: URL? = nil) {
            self.username = username
            self.baseURL = baseURL ?? GitHubAPI.baseURL
        }
    }

    public init() {}

    public func makeRequest(from data: Parameter) throws -> URLRequest {
        var components = URLComponents()
        components.path = "/users/\(data.username)"

        guard let url = components.url(relativeTo: data.baseURL) else {
            throw GHError.invalidRequestParameter
        }

        return URLRequest(url: url)
    }

    public func parseResponse(data: Data) throws -> ResponseDataType {
        return try GitHubAPI.decoder.decode(ResponseDataType.self, from: data)
    }
}
