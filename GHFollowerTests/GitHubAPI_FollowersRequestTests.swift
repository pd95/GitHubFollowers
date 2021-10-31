//
//  GitHubAPI_FollowersRequestTests.swift
//  GHFollowerTests
//
//  Created by Philipp on 31.10.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

@testable import GHFollower
import XCTest

class GitHubAPI_FollowersRequestTests: XCTestCase {
    func testMakingURLRequest() throws {
        let username = "sallen0400"
        let page = 1
        let maxNumberPerPage = 10

        let urlRequest = try GitHubAPI.FollowersRequest.makeRequest(username: username, page: page, maxNumberPerPage: maxNumberPerPage)

        XCTAssertEqual(urlRequest.url?.scheme, "https")
        XCTAssertEqual(urlRequest.url?.host, "api.github.com")
        XCTAssertEqual(urlRequest.url?.path, "/users/\(username)/followers")
        XCTAssertTrue(urlRequest.url?.query?.contains("page=\(page)") ?? false)
        XCTAssertTrue(urlRequest.url?.query?.contains("per_page=\(maxNumberPerPage)") ?? false)
    }

    func testParsingResponse() throws {
        let login = "octocat"
        let avatarURLString = "https://github.com/images/error/octocat_happy.gif"
        let jsonData = "[{\"login\":\"\(login)\", \"avatar_url\": \"\(avatarURLString)\"}]".data(using: .utf8)!

        let response = try GitHubAPI.FollowersRequest.parseResponse(data: jsonData)

        XCTAssertEqual(response, [Follower(login: login, avatarUrl: avatarURLString)])
    }
}
