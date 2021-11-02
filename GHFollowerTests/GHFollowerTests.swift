//
//  GHFollowerTests.swift
//  GHFollowerTests
//
//  Created by Philipp on 31.10.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

@testable import GHFollower
import XCTest

class GHFollowerTests: XCTestCase {
    func test_NetworkManager_getUserInfo() throws {
        let exp = expectation(description: "Request completes")

        makeNetworkManager().getUserInfo(for: "octocat") { result in
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

    func test_NetworkManager_getFollowers() throws {
        let exp = expectation(description: "Request completes")

        makeNetworkManager().getFollowers(for: "octocat", page: 1) { result in
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

    func makeNetworkManager() -> NetworkManager {
        let networkManager = NetworkManager(urlSession: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(networkManager)
        return networkManager
    }
}
