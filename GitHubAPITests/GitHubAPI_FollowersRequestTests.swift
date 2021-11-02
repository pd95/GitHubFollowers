//
//  GitHubAPI_FollowersRequestTests.swift
//  GitHubAPITests
//
//  Created by Philipp on 31.10.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import GitHubAPI
import XCTest

class GitHubAPI_FollowersRequestTests: XCTestCase {
    private typealias APIRequestToTest = FollowersRequest
    private let request = APIRequestToTest()

    func test_MakingValidURLRequest() throws {
        let username = "sallen0400"
        let page = 1
        let maxNumberPerPage = 10

        let urlRequest = try request.makeRequest(from: .init(username: username, page: page, maxNumberPerPage: maxNumberPerPage))

        XCTAssertEqual(urlRequest.url?.scheme, "https")
        XCTAssertEqual(urlRequest.url?.host, "api.github.com")
        XCTAssertEqual(urlRequest.url?.path, "/users/\(username)/followers")
        XCTAssertTrue(urlRequest.url?.query?.contains("page=\(page)") ?? false)
        XCTAssertTrue(urlRequest.url?.query?.contains("per_page=\(maxNumberPerPage)") ?? false)
    }

    func test_MakingURLRequestWithInvalidURLCharacterInUsername() throws {
        let invalidCharacters = [" ", "%", "😉"]
        for character in invalidCharacters {
            XCTAssertThrowsError(try request.makeRequest(from: .init(username: "username\(character)", page: 1)))
        }
    }

    func test_ParsingValidResponse() throws {
        let (followers, json) = anyFollowers()
        let jsonData = makeFollowerJSON(json)

        let response = try request.parseResponse(data: jsonData)

        XCTAssertEqual(response, followers)
    }

    func test_APILoaderLoadsFollowersSuccessfully() {
        let username = "octocat"
        let (followers, json) = anyFollowers()
        let jsonData = makeFollowerJSON(json)

        let loader = makeLoader()
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.pathComponents.contains(username), true)
            return (HTTPURLResponse(), jsonData)
        }

        let expectation = XCTestExpectation(description: "response")
        loader.loadAPIRequest(requestData: .init(username: username, page: 1, maxNumberPerPage: 10)) { result in
            XCTAssertEqual(result, .success(followers))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    // MARK: - Helpers

    private func makeLoader(file: StaticString = #filePath, line: UInt = #line) -> APIRequestLoader<APIRequestToTest> {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        let loader = APIRequestLoader(apiRequest: request, urlSession: urlSession)
        trackForMemoryLeaks(loader, file: file, line: line)
        return loader
    }

    private func anyFollowers() -> (follower: [GHFollower], json: [[String: Any]]) {
        let (follower, json) = makeFollower(login: "octocat", avatarUrl: "https://avatars.githubusercontent.com/u/583231?v=4")
        return ([follower], [json])
    }

    private func makeFollower(login: String, avatarUrl: String) -> (follower: GHFollower, json: [String: Any]) {
        let follower = GHFollower(
            login: login, avatarUrl: avatarUrl
        )

        let followerDict: [String: Any?] = [
            "login": login,
            "avatar_url": avatarUrl,
        ]
        let json = followerDict.compactMapValues { $0 }

        return (follower, json)
    }

    private func makeFollowerJSON(_ followers: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: followers)
    }
}
