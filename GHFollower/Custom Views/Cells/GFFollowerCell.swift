//
//  GFFollowerCell.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

class GFFollowerCell: UICollectionViewCell {

    static let reuseID = "GFFollowerCell"
    
    @IBOutlet var avatarImageView : GFAvatarImageView!
    @IBOutlet var usernameLabel : GFTitleLabel!

    override func prepareForReuse() {
        usernameLabel.text = nil
        usernameLabel.set(textAlignment: .center, fontSize: 16)
    }
    
    func set(follower: Follower) {
        usernameLabel.text = follower.login
        avatarImageView.image = Images.placeholder
        avatarImageView.downloadImage(fromUrl: follower.avatarUrl)
    }
}
