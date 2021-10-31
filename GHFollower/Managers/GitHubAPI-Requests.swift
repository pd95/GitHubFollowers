//
//  GitHubAPI-Requests.swift
//  GHFollower
//
//  Created by Philipp on 31.10.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

protocol APIRequest {
    associatedtype RequestDataType
    associatedtype ResponseDataType

    func makeRequest(from data: RequestDataType) throws -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
}

extension GitHubAPI {
    struct FollowersRequest: APIRequest {
        typealias RequestDataType = Parameter
        typealias ResponseDataType = [Follower]

        struct Parameter {
            let username: String
            let page: Int
            var maxNumberPerPage: Int = 100
        }

        func makeRequest(from data: Parameter) throws -> URLRequest {
            var components = URLComponents(string: "\(baseURL)/users/\(data.username)/followers")!
            components.queryItems = [
                URLQueryItem(name: "per_page", value: String(data.maxNumberPerPage)),
                URLQueryItem(name: "page", value: String(data.page)),
            ]

            guard let url = components.url else {
                throw GFError.invalidUsername
            }
            return URLRequest(url: url)
        }

        func parseResponse(data: Data) throws -> [Follower] {
            return try GitHubAPI.decoder.decode(ResponseDataType.self, from: data)
        }
    }

    struct UserInfoRequest: APIRequest {
        typealias RequestDataType = Parameter
        typealias ResponseDataType = User

        struct Parameter {
            let username: String
        }

        func makeRequest(from data: Parameter) throws -> URLRequest {
            guard let url = URL(string: "\(baseURL)/users/\(data.username)") else {
                throw GFError.invalidUsername
            }

            return URLRequest(url: url)
        }

        func parseResponse(data: Data) throws -> User {
            return try GitHubAPI.decoder.decode(ResponseDataType.self, from: data)
        }
    }
}
