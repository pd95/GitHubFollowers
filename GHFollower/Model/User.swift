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

    static let example = User(login: "devjmitchell",
                              avatarUrl: "https://avatars0.githubusercontent.com/u/8109229?v=4",
                              name: "Jason Mitchell",
                              location: "AZ",
                              bio: "Dad 👑 Husband 💑 #USMC Veteran 🇺🇸 #iOSdev 🐒 @swift_podcast Co-host 🎙 Occasional YouTuber 🎞 AI Robot 🤖 Runner 🏃‍♂️ #SwiftLang COFFEE! ☕️",
                              publicRepos: 48,
                              publicGists: 0,
                              htmlUrl: "https://github.com/devjmitchell",
                              following: 21,
                              followers: 6,
                              createdAt: ISO8601DateFormatter().date(from: "2014-07-09T02:50:47Z")!
    )

}
