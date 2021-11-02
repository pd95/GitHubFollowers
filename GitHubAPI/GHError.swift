//
//  GHError.swift
//  GitHubAPI
//
//  Created by Philipp on 02.11.21.
//  Copyright © 2021 Philipp. All rights reserved.
//

import Foundation

public enum GHError: Error {
    case invalidRequestParameter
    case unableToComplete
    case invalidResponse
    case invalidData
}
