//
//  UserInfoRequestTests.swift
//  GitHubAPITests
//
//  Created by Philipp on 31.10.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import GitHubAPI
import XCTest

class UserInfoRequestTests: XCTestCase {
    private typealias APIRequestToTest = UserInfoRequest
    private let request = APIRequestToTest()

    func test_MakingValidURLRequest() throws {
        let username = "sallen0400"

        let urlRequest = try request.makeRequest(from: makeRequestParameter(username: username))

        XCTAssertEqual(urlRequest.url?.scheme, "https")
        XCTAssertEqual(urlRequest.url?.host, "api.github.com")
        XCTAssertEqual(urlRequest.url?.path, "/users/\(username)")
    }

    func test_MakingURLRequestWithInvalidURLCharacterInUsername() throws {
        let invalidCharacters = [" ", "%", "😉"]
        for character in invalidCharacters {
            XCTAssertNotNil(try? request.makeRequest(from: makeRequestParameter(username: "username\(character)")))
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

        let loader = makeLoader()
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.pathComponents.contains(login), true)
            return (HTTPURLResponse(), jsonData)
        }

        let expectation = XCTestExpectation(description: "response")
        loader.loadAPIRequest(requestData: makeRequestParameter(username: login)) { result in
            switch result {
            case let .success(receivedUser):
                XCTAssertEqual(receivedUser, user)
            default:
                XCTFail("Expected success but got \(result) instead.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    // MARK: - Helpers

    private func makeRequestParameter(username: String, baseURL: URL = URL(string: "https://api.github.com")!) -> APIRequestToTest.Parameter {
        APIRequestToTest.Parameter(username: username, baseURL: baseURL)
    }

    private func makeLoader(file: StaticString = #filePath, line: UInt = #line) -> APIRequestLoader<APIRequestToTest> {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        let loader = APIRequestLoader(apiRequest: request, urlSession: urlSession)
        trackForMemoryLeaks(loader, file: file, line: line)
        return loader
    }

    private func anyUser(login: String = "octocat") -> (user: GHUser, json: [String: Any]) {
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
    ) -> (user: GHUser, json: [String: Any]) {
        let user = GHUser(
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
