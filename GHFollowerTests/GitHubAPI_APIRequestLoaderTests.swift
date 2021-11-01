//
//  GitHubAPI_APIRequestLoaderTests.swift
//  GHFollowerTests
//
//  Created by Philipp on 01.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

@testable import GHFollower
import XCTest

class GitHubAPI_APIRequestLoaderTests: XCTestCase {
    var loader: APIRequestLoader<GitHubAPI.UserInfoRequest>!

    override func setUp() {
        let request = GitHubAPI.UserInfoRequest()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        loader = APIRequestLoader(apiRequest: request, urlSession: urlSession)
    }

    func test_LoaderSuccess() {
        let login = "octocat"
        let avatarUrl = "https://avatars.githubusercontent.com/u/583231?v=4"
        let name: String? = "The Octocat"
        let location: String? = "San Francisco"
        let bio: String? = nil
        let publicRepos: Int = 8
        let publicGists: Int = 8
        let htmlUrl: String = "https://github.com/octocat"
        let following: Int = 9
        let followers: Int = 4110
        let createdAt = Date(timeIntervalSince1970: 1_295_981_076)

        let (user, json) = makeUser(
            login: login, avatarUrl: avatarUrl, name: name, location: location, bio: bio,
            publicRepos: publicRepos, publicGists: publicGists, htmlUrl: htmlUrl,
            following: following, followers: followers, createdAt: createdAt
        )

        let jsonData = makeUserJSON(json)

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.pathComponents.contains(login), true)
            return (HTTPURLResponse(), jsonData)
        }

        let expectation = XCTestExpectation(description: "response")
        loader.loadAPIRequest(requestData: .init(username: login)) { result in
            XCTAssertEqual(result, .success(user))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    // MARK: - Helpers

    func makeUser(login: String, avatarUrl: String, name: String? = nil, location: String? = nil, bio: String? = nil,
                  publicRepos: Int, publicGists: Int, htmlUrl: String, following: Int, followers: Int,
                  createdAt: Date) -> (user: User, json: [String: Any])
    {
        let user = User(
            login: login, avatarUrl: avatarUrl, name: name, location: location, bio: bio,
            publicRepos: publicRepos, publicGists: publicGists, htmlUrl: htmlUrl,
            following: following, followers: followers, createdAt: createdAt
        )

        let userDict: [String: Any?] = [
            "login": login,
            "avatar_url": avatarUrl,
            "name": name,
            "location": location,
            "bio": bio,
            "public_repos": publicRepos,
            "public_gists": publicGists,
            "html_url": htmlUrl,
            "following": following,
            "followers": followers,
            "created_at": ISO8601DateFormatter().string(from: createdAt),
        ]

        let json = userDict.compactMapValues { $0 }

        return (user, json)
    }

    func makeUserJSON(_ user: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: user)
    }
}
