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
    private struct DummyRequest: APIRequest {
        typealias RequestDataType = URL
        typealias ResponseDataType = [String]

        func makeRequest(from url: URL) throws -> URLRequest {
            URLRequest(url: url)
        }

        func parseResponse(data: Data) throws -> [String] {
            try JSONDecoder().decode([String].self, from: data)
        }
    }

    func test_loadAPIRequest_performsGetRequestWithURL() {
        let url = URL(string: "http://localhost")!
        let exp = expectation(description: "Wait for request")

        let sut = makeSUT()
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()

            return (HTTPURLResponse(), Data())
        }

        sut.loadAPIRequest(requestData: url) { _ in }

        wait(for: [exp], timeout: 1.0)
    }

    func test_loadAPIRequest_failsOnRequestError() {
        let requestError = anyNSError()
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError)

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedError as? GFError, GFError.unableToComplete)
    }

    func test_loadAPIRequest_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: nil))
    }

    func test_loadAPIRequest_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()

        let receivedValues = resultValuesFor(data: data, response: response, error: nil)

        XCTAssertEqual(receivedValues, ["Hello"])
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> APIRequestLoader<DummyRequest> {
        let request = DummyRequest()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        let loader = APIRequestLoader(apiRequest: request, urlSession: urlSession)
        trackForMemoryLeaks(loader, file: file, line: line)
        return loader
    }

    private func resultValuesFor(
        data: Data?, response: URLResponse?, error: Error?,
        file: StaticString = #filePath, line: UInt = #line
    ) -> DummyRequest.ResponseDataType? {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)

        switch result {
        case let .success(response):
            return response
        default:
            XCTFail("Expected success, got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultErrorFor(
        data: Data?, response: URLResponse?, error: Error?,
        file: StaticString = #filePath, line: UInt = #line
    ) -> Error? {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)

        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultFor(
        data: Data?, response: URLResponse?, error: Error?,
        file: StaticString = #filePath, line: UInt = #line
    ) -> Result<DummyRequest.ResponseDataType, GFError> {
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")

        // Mocking the result
        MockURLProtocol.requestHandler = { _ in
            if let error = error {
                throw error
            }
            return (response ?? .init(), data ?? .init())
        }

        var receivedResult: Result<DummyRequest.ResponseDataType, GFError>!
        sut.loadAPIRequest(requestData: anyURL()) { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }

    private func anyURL() -> URL {
        URL(string: "http://localhost")!
    }

    private func anyNSError() -> NSError {
        NSError(domain: "anyError", code: 0)
    }

    private func anyData() -> Data {
        "[\"Hello\"]".data(using: .utf8)!
    }

    private func nonHTTPURLResponse() -> URLResponse {
        URLResponse()
    }

    private func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse()
    }
}
