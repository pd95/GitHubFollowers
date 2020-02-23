//
//  GFRepoItemViewController.swift
//  GHFollower
//
//  Created by Philipp on 11.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

protocol GFRepoItemInfoViewControllerDelegate: class {
    func didTapGitHubProfile(for user: User)
}


class GFRepoItemViewController: GFItemInfoViewController {

    weak var delegate: GFRepoItemInfoViewControllerDelegate!

    
    override func set(user: User) {
        super.set(user: user)
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
    }

    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
