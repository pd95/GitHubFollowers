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

        public init(username: String, page: Int, maxNumberPerPage: Int = 100) {
            self.username = username
            self.page = page
            self.maxNumberPerPage = maxNumberPerPage
        }
    }

    public init() {}

    public func makeRequest(from data: Parameter) throws -> URLRequest {
        guard var components = URLComponents(string: "\(GitHubAPI.baseURL.absoluteString)/users/\(data.username)/followers") else {
            throw GHError.invalidRequestParameter
        }
        components.queryItems = [
            URLQueryItem(name: "per_page", value: String(data.maxNumberPerPage)),
            URLQueryItem(name: "page", value: String(data.page)),
        ]

        guard let url = components.url else {
            throw GHError.invalidRequestParameter
        }
        return URLRequest(url: url)
    }

    public func parseResponse(data: Data) throws -> ResponseDataType {
        return try GitHubAPI.decoder.decode(ResponseDataType.self, from: data)
    }
}
