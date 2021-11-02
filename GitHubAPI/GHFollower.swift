//
//  GHFollower.swift
//  GitHubAPI
//
//  Created by Philipp on 02.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

public struct GHFollower: Codable, Hashable {
    public let login: String
    public let avatarUrl: String

    public init(login: String, avatarUrl: String) {
        self.login = login
        self.avatarUrl = avatarUrl
    }
}
