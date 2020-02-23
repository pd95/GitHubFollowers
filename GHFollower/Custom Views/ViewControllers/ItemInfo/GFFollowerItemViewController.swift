//
//  GFFollowerItemViewController.swift
//  GHFollower
//
//  Created by Philipp on 11.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

protocol GFFollowerItemInfoViewControllerDelegate: class {
    func didTapGetFollowers(for user: User)
}


class GFFollowerItemViewController: GFItemInfoViewController {

    weak var delegate: GFFollowerItemInfoViewControllerDelegate!

    
    override func set(user: User) {
        super.set(user: user)
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
    }

    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
