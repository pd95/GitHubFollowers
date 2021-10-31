//
//  GitHubAPI.swift
//  GHFollower
//
//  Created by Philipp on 31.10.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

enum GitHubAPI {
    static let baseURL = "https://api.github.com"

    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

extension GitHubAPI {
    enum FollowersRequest {
        static func makeRequest(username: String, page: Int, maxNumberPerPage: Int = 100) throws -> URLRequest {
            var components = URLComponents(string: "\(baseURL)/users/\(username)/followers")!
            components.queryItems = [
                URLQueryItem(name: "per_page", value: String(maxNumberPerPage)),
                URLQueryItem(name: "page", value: String(page)),
            ]

            return URLRequest(url: components.url!)
        }

        static func parseResponse(data: Data) throws -> [Follower] {
            return try GitHubAPI.decoder.decode([Follower].self, from: data)
        }
    }
}
