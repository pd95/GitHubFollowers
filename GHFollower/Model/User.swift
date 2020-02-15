//
//  User.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    let name: String?
    let location: String?
    let bio: String?
    
    let publicRepos: Int
    let publicGists: Int
    
    let htmlUrl: String
    let following: Int
    let followers: Int
    
    let createdAt: Date
}
