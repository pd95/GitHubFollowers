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

    private let baseURL = "https://api.github.com/users/"
    private let cache = NSCache<NSString, UIImage>()

    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        var loader = Optional.some(APIRequestLoader(apiRequest: FollowersRequest(), urlSession: urlSession))
        loader?.loadAPIRequest(requestData: .init(username: username, page: page)) { result in
            switch result {
            case let .success(followers):
                completed(.success(followers.map(\.follower)))
            case let .failure(error):
                completed(.failure(error.gfError))
            }
            loader = nil
        }
    }

    func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
        var loader = Optional.some(APIRequestLoader(apiRequest: UserInfoRequest(), urlSession: urlSession))
        loader?.loadAPIRequest(requestData: .init(username: username)) { result in
            switch result {
            case let .success(ghUser):
                completed(.success(ghUser.user))
            case let .failure(error):
                completed(.failure(error.gfError))
            }
            loader = nil
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
