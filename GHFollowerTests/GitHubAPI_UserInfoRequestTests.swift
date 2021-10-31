//
//  GitHubAPI_UserInfoRequestTests.swift
//  GHFollowerTests
//
//  Created by Philipp on 31.10.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

@testable import GHFollower
import XCTest

class GitHubAPI_UserInfoRequestTests: XCTestCase {
    let request = GitHubAPI.UserInfoRequest()

    func testMakingURLRequest() throws {
        let username = "sallen0400"

        let urlRequest = try request.makeRequest(from: .init(username: username))

        XCTAssertEqual(urlRequest.url?.scheme, "https")
        XCTAssertEqual(urlRequest.url?.host, "api.github.com")
        XCTAssertEqual(urlRequest.url?.path, "/users/\(username)")
    }

    func testParsingResponse() throws {
        let login = "octocat"
        let avatarURLString = "https://avatars.githubusercontent.com/u/583231?v=4"
        let name: String? = "The Octocat"
        let location: String? = "San Francisco"
        let bio: String? = nil
        let publicRepos: Int = 8
        let publicGists: Int = 8
        let htmlUrl: String = "https://github.com/octocat"
        let following: Int = 9
        let followers: Int = 4110
        let createdAt = Date(timeIntervalSince1970: 1_295_981_076)

        let jsonData = """
        {
            "login": "\(login)",
            "avatar_url": "\(avatarURLString)",
            "name": "\(name ?? "null")",
            "location": "\(location ?? "null")",
            "bio": \(bio ?? "null"),
            "public_repos": \(publicRepos),
            "public_gists": \(publicGists),
            "html_url": "\(htmlUrl)",
            "following": \(following),
            "followers": \(followers),
            "created_at": "2011-01-25T18:44:36Z"
        }
        """.data(using: .utf8)!

        let response = try request.parseResponse(data: jsonData)

        XCTAssertEqual(response, User(login: login, avatarUrl: avatarURLString, name: name, location: location, bio: bio, publicRepos: publicRepos, publicGists: publicGists, htmlUrl: htmlUrl, following: following, followers: followers, createdAt: createdAt))
    }
}
