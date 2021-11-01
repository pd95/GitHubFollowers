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

    func test_MakingValidURLRequest() throws {
        let username = "sallen0400"

        let urlRequest = try request.makeRequest(from: .init(username: username))

        XCTAssertEqual(urlRequest.url?.scheme, "https")
        XCTAssertEqual(urlRequest.url?.host, "api.github.com")
        XCTAssertEqual(urlRequest.url?.path, "/users/\(username)")
    }

    func test_MakingURLRequestWithInvalidURLCharacterInUsername() throws {
        let invalidCharacters = [" ", "%", "😉"]
        for character in invalidCharacters {
            XCTAssertThrowsError(try request.makeRequest(from: .init(username: "username\(character)")))
        }
    }

    func test_ParsingValidResponse() throws {
        let (user, json) = anyUser()
        let jsonData = makeUserJSON(json)
        let response = try request.parseResponse(data: jsonData)

        XCTAssertEqual(response, user)
    }

    func test_APILoaderLoadsUserSuccessfully() {
        let login = "octocat"
        let (user, json) = anyUser(login: login)
        let jsonData = makeUserJSON(json)

        let sut = makeSUT()
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.pathComponents.contains(login), true)
            return (HTTPURLResponse(), jsonData)
        }

        let expectation = XCTestExpectation(description: "response")
        sut.loadAPIRequest(requestData: .init(username: login)) { result in
            XCTAssertEqual(result, .success(user))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> APIRequestLoader<GitHubAPI.UserInfoRequest> {
        let request = GitHubAPI.UserInfoRequest()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        let loader = APIRequestLoader(apiRequest: request, urlSession: urlSession)
        trackForMemoryLeaks(loader, file: file, line: line)
        return loader
    }

    private func anyUser(login: String = "octocat") -> (user: User, json: [String: Any]) {
        let avatarUrl = "https://avatars.githubusercontent.com/u/583231?v=4"
        let name: String? = "The Octocat"
        let location: String? = "San Francisco"
        let bio: String? = nil
        let publicRepos: Int = 8
        let publicGists: Int = 8
        let htmlUrl: String = "https://github.com/\(login)"
        let following: Int = 9
        let followers: Int = 4110
        let createdAt = Date(timeIntervalSince1970: 1_295_981_076)

        return makeUser(
            login: login, avatarUrl: avatarUrl, name: name, location: location, bio: bio,
            publicRepos: publicRepos, publicGists: publicGists, htmlUrl: htmlUrl,
            following: following, followers: followers, createdAt: createdAt
        )
    }

    private func makeUser(
        login: String, avatarUrl: String, name: String? = nil, location: String? = nil, bio: String? = nil,
        publicRepos: Int, publicGists: Int, htmlUrl: String, following: Int, followers: Int,
        createdAt: Date
    ) -> (user: User, json: [String: Any]) {
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

    private func makeUserJSON(_ user: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: user)
    }
}
