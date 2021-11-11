//
//  GitHubAPI.swift
//  GitHubAPI
//
//  Created by Philipp on 31.10.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

struct GitHubAPI {
    static let baseURL = URL(string: "https://api.github.com")!

    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
