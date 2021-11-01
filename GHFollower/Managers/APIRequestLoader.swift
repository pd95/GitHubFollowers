//
//  APIRequestLoader.swift
//  GHFollower
//
//  Created by Philipp on 31.10.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

class APIRequestLoader<T: APIRequest> {
    let apiRequest: T
    let urlSession: URLSession

    init(apiRequest: T, urlSession: URLSession = .shared) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
    }

    func loadAPIRequest(
        requestData: T.RequestDataType,
        completionHandler: @escaping (Result<T.ResponseDataType, GFError>) -> Void
    ) {
        do {
            let urlRequest = try apiRequest.makeRequest(from: requestData)
            urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
                guard let self = self else { return }
                if let _ = error {
                    return completionHandler(.failure(.unableToComplete))
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return completionHandler(.failure(.invalidResponse))
                }

                guard let data = data,
                      let parsedResponse = try? self.apiRequest.parseResponse(data: data)
                else {
                    return completionHandler(.failure(.invalidData))
                }

                completionHandler(.success(parsedResponse))
            }.resume()
        } catch let error as GFError {
            return completionHandler(.failure(error))
        } catch {
            return completionHandler(.failure(.unableToComplete))
        }
    }
}
