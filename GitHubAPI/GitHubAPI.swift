//
//  GitHubAPI.swift
//  GitHubAPI
//
//  Created by Philipp on 31.10.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

public struct GitHubAPI {
    public static let `default` = GitHubAPI()

    private var urlSession: URLSession
    var baseURL: URL

    public init(urlSession: URLSession = .shared, baseURL: URL = URL(string: "https://api.github.com")!) {
        self.urlSession = urlSession
        self.baseURL = baseURL
    }

    public func getFollowers(for username: String, page: Int, completed: @escaping (Result<[GHFollower], GHError>) -> Void) {
        var loader = Optional(APIRequestLoader(apiRequest: FollowersRequest(), urlSession: urlSession))
        loader?.loadAPIRequest(requestData: .init(username: username, page: page, baseURL: baseURL)) { result in
            switch result {
            case let .success(followers):
                completed(.success(followers))
            case let .failure(error):
                completed(.failure(error))
            }
            loader = nil
        }
    }

    public func getUserInfo(for username: String, completed: @escaping (Result<GHUser, GHError>) -> Void) {
        var loader = Optional(APIRequestLoader(apiRequest: UserInfoRequest(), urlSession: urlSession))
        loader?.loadAPIRequest(requestData: .init(username: username, baseURL: baseURL)) { result in
            switch result {
            case let .success(user):
                completed(.success(user))
            case let .failure(error):
                completed(.failure(error))
            }
            loader = nil
        }
    }

    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
