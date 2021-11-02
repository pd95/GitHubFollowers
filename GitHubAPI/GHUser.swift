//
//  GHUser.swift
//  GitHubAPI
//
//  Created by Philipp on 02.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

public struct GHUser: Codable, Equatable {
    public let login: String
    public let avatarUrl: String
    public let name: String?
    public let location: String?
    public let bio: String?

    public let publicRepos: Int
    public let publicGists: Int

    public let htmlUrl: String
    public let following: Int
    public let followers: Int

    public let createdAt: Date

    public init(
        login: String, avatarUrl: String, name: String?, location: String?, bio: String?,
        publicRepos: Int, publicGists: Int, htmlUrl: String, following: Int, followers: Int,
        createdAt: Date
    ) {
        self.login = login
        self.avatarUrl = avatarUrl
        self.name = name
        self.location = location
        self.bio = bio
        self.publicRepos = publicRepos
        self.publicGists = publicGists
        self.htmlUrl = htmlUrl
        self.following = following
        self.followers = followers
        self.createdAt = createdAt
    }
}
