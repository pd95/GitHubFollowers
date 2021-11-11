//
//  FollowersRequest.swift
//  GitHubAPI
//
//  Created by Philipp on 02.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

public struct FollowersRequest: APIRequest {
    public typealias RequestDataType = Parameter
    public typealias ResponseDataType = [GHFollower]

    public struct Parameter {
        let username: String
        let page: Int
        var maxNumberPerPage: Int
        var baseURL: URL

        public init(username: String, page: Int, maxNumberPerPage: Int = 100, baseURL: URL? = nil) {
            self.username = username
            self.page = page
            self.maxNumberPerPage = maxNumberPerPage
            self.baseURL = baseURL ?? GitHubAPI.baseURL
        }
    }

    public init() {}

    public func makeRequest(from data: Parameter) throws -> URLRequest {
        var components = URLComponents()
        components.path = "/users/\(data.username)/followers"
        components.queryItems = [
            URLQueryItem(name: "per_page", value: String(data.maxNumberPerPage)),
            URLQueryItem(name: "page", value: String(data.page)),
        ]

        guard let url = components.url(relativeTo: data.baseURL) else {
            throw GHError.invalidRequestParameter
        }
        return URLRequest(url: url)
    }

    public func parseResponse(data: Data) throws -> ResponseDataType {
        return try GitHubAPI.decoder.decode(ResponseDataType.self, from: data)
    }
}
