//
//  GitHubAPI-Converter.swift
//  GHFollower
//
//  Created by Philipp on 02.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import GitHubAPI

extension GHUser {
    var user: User {
        User(login: login, avatarUrl: avatarUrl, name: name, location: location, bio: bio,
             publicRepos: publicRepos, publicGists: publicGists, htmlUrl: htmlUrl, following: following, followers: followers, createdAt: createdAt)
    }
}

extension GHFollower {
    var follower: Follower {
        Follower(login: login, avatarUrl: avatarUrl)
    }
}

extension GHError {
    var gfError: GFError {
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
