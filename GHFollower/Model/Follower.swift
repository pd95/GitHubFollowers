//
//  Follower.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import Foundation

struct Follower: Codable, Hashable, Identifiable {
    let login: String
    let avatarUrl: String

    var id: String { login }

    static let examples : [Follower] = [
        .init(login: "dmyma", avatarUrl: "https://avatars2.githubusercontent.com/u/5744315?v=4"),
        .init(login: "vexadall", avatarUrl: "https://avatars0.githubusercontent.com/u/11519870?v=4"),
        .init(login: "devjmitchell", avatarUrl: "https://avatars0.githubusercontent.com/u/8109229?v=4")
    ]
}
