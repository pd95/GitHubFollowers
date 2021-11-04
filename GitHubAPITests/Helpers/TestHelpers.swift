//
//  TestHelpers.swift
//  GitHubAPITests
//
//  Created by Philipp on 04.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

func anyURL() -> URL {
    URL(string: "https://localhost")!
}

func anyNSError() -> NSError {
    NSError(domain: "anyError", code: 0)
}

func anyData() -> Data {
    "[\"Hello\"]".data(using: .utf8)!
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
