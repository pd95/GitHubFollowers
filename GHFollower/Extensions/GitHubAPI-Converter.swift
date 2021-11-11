//
//  GitHubAPI-Converter.swift
//  GHFollower
//
//  Created by Philipp on 02.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import GitHubAPI

extension GHUser {
    func toModel() -> User {
        User(login: login, avatarUrl: avatarUrl, name: name, location: location, bio: bio,
             publicRepos: publicRepos, publicGists: publicGists, htmlUrl: htmlUrl, following: following, followers: followers, createdAt: createdAt)
    }
}

extension Array where Element == GHFollower {
    func toModel() -> [Follower] {
        map { Follower(login: $0.login, avatarUrl: $0.avatarUrl) }
    }
}

extension GHError {
    func toModel() -> GFError {
        switch self {
        case .invalidRequestParameter:
            return .invalidUsername
        case .unableToComplete:
            return .unableToComplete
        case .invalidResponse:
            return .invalidResponse
        case .invalidData:
            return .invalidData
        }
    }
}
