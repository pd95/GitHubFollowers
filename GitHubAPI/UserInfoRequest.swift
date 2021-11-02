//
//  UserInfoRequest.swift
//  GitHubAPI
//
//  Created by Philipp on 02.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

public struct UserInfoRequest: APIRequest {
    public typealias RequestDataType = Parameter
    public typealias ResponseDataType = GHUser

    public struct Parameter {
        let username: String

        public init(username: String) {
            self.username = username
        }
    }

    public init() {}

    public func makeRequest(from data: Parameter) throws -> URLRequest {
        guard let url = URL(string: "\(Globals.baseURL)/users/\(data.username)") else {
            throw GHError.invalidRequestParameter
        }

        return URLRequest(url: url)
    }

    public func parseResponse(data: Data) throws -> ResponseDataType {
        return try Globals.decoder.decode(ResponseDataType.self, from: data)
    }
}
