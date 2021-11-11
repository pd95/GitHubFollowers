//
//  NetworkManager.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import GitHubAPI
import UIKit

class NetworkManager {
    static var shared = NetworkManager()

    private let cache = NSCache<NSString, UIImage>()

    private let urlSession: URLSession
    private let api: GitHubAPI

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        api = GitHubAPI(urlSession: urlSession)
    }

    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        api.getFollowers(for: username, page: page) { result in
            switch result {
            case let .success(followers):
                completed(.success(followers.toModel()))
            case let .failure(error):
                completed(.failure(error.toModel()))
            }
        }
    }

    func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
        api.getUserInfo(for: username) { result in
            switch result {
            case let .success(user):
                completed(.success(user.toModel()))
            case let .failure(error):
                completed(.failure(error.toModel()))
            }
        }
    }

    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }

        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }

        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data)
            else {
                completed(nil)
                return
            }

            self.cache.setObject(image, forKey: cacheKey)

            completed(image)
        }

        task.resume()
    }
}
