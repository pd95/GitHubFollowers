//
//  GFFavoriteCell.swift
//  GHFollower
//
//  Created by Philipp on 15.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

class GFFavoriteCell: UITableViewCell {

    static let reuseID = "GFFavoriteCell"
    
    @IBOutlet var avatarImageView : GFAvatarImageView!
    @IBOutlet var usernameLabel : GFTitleLabel!

    override func prepareForReuse() {
        usernameLabel.text = nil
        usernameLabel.set(textAlignment: .left, fontSize: 26)
    }

    func set(favorite: Follower) {
        usernameLabel.text = favorite.login
        avatarImageView.image = Images.placeholder
        avatarImageView.downloadImage(fromUrl: favorite.avatarUrl)
    }
}
