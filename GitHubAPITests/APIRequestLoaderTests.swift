//
//  APIRequestLoaderTests.swift
//  GitHubAPITests
//
//  Created by Philipp on 01.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import GitHubAPI
import XCTest

class APIRequestLoaderTests: XCTestCase {
    private typealias APIRequestToTest = DummyRequest

    private struct DummyRequest: APIRequest {
        typealias RequestDataType = (url: URL, error: Error?)
        typealias ResponseDataType = [String]

        func makeRequest(from input: (url: URL, error: Error?)) throws -> URLRequest {
            if let error = input.error {
                throw error
            }
            return URLRequest(url: input.url)
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

        sut.loadAPIRequest(requestData: (url, nil)) { _ in }

        wait(for: [exp], timeout: 1.0)
    }

    func test_loadAPIRequest_mayFailOnMakeRequest() throws {
        MockURLProtocol.requestHandler = { _ in
            (HTTPURLResponse(), Data())
        }

        let testErrors: [Error] = [GHError.invalidRequestParameter, anyNSError()]

        // Input should fail with given error in `makeRequest`
        for error in testErrors {
            let sut = makeSUT()
            let exp = expectation(description: "Wait for completion")
            sut.loadAPIRequest(requestData: (anyURL(), error)) { result in
                switch result {
                case .success:
                    XCTFail("Expected failure for error during makeRequest")
                case .failure(let receivedError):
                    XCTAssertNotNil(receivedError)
                }
                exp.fulfill()
            }
            wait(for: [exp], timeout: 1.0)
        }
    }

    func test_loadAPIRequest_failsOnOnNon200HTTPResponse() throws {
        let statusCodesToTest = [199, 201, 300, 400, 500]

        statusCodesToTest.forEach { code in
            let error = resultErrorFor(data: anyData(), response: HTTPURLResponse(statusCode: code), error: nil)
            XCTAssertNotNil(error, "Expected error for HTTP status code \(code)")
        }
    }

    func test_loadAPIRequest_failsOnRequestError() {
        let requestError = anyNSError()
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError)

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedError as? GHError, GHError.unableToComplete)
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

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> APIRequestLoader<APIRequestToTest> {
        let request = APIRequestToTest()

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
    ) -> APIRequestToTest.ResponseDataType? {
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
    ) -> Result<APIRequestToTest.ResponseDataType, GHError> {
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")

        // Mocking the result
        MockURLProtocol.requestHandler = { _ in
            if let error = error {
                throw error
            }
            return (response ?? .init(), data ?? .init())
        }

        var receivedResult: Result<APIRequestToTest.ResponseDataType, GHError>!
        sut.loadAPIRequest(requestData: (anyURL(), nil)) { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }

    private func nonHTTPURLResponse() -> URLResponse {
        URLResponse()
    }

    private func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse()
    }
}
