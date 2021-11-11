//
//  GitHubAPI_E2E_Tests.swift
//  GitHubAPITests
//
//  Created by Philipp on 11.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import GitHubAPI
import XCTest

class GitHubAPI_E2E_Tests: XCTestCase {
    func test_GitHubAPI_getUserInfo() throws {
        let exp = expectation(description: "Request completes")

        makeSUT().getUserInfo(for: "octocat") { result in
            switch result {
            case let .success(user):
                XCTAssertEqual(user.login, "octocat")
                XCTAssertEqual(user.name, "The Octocat")

            case let .failure(error):
                XCTFail("Unexpected error \(error)")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 3.0)
    }

    func test_GitHubAPI_getFollowers() throws {
        let exp = expectation(description: "Request completes")

        makeSUT().getFollowers(for: "octocat", page: 1) { result in
            switch result {
            case let .success(followers):
                XCTAssert(followers.count > 0, "Expected followers for, but found \(followers)")

            case let .failure(error):
                XCTFail("Unexpected error \(error)")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 3.0)
    }

    // MARK: - Helpers

    func makeSUT() -> GitHubAPI {
        let configuration = URLSessionConfiguration.ephemeral
        // configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        let api = GitHubAPI(urlSession: urlSession)
        // trackForMemoryLeaks(api)
        return api
    }
}
