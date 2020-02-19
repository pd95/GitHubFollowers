//
//  GFUserInfoHeaderViewController.swift
//  GHFollower
//
//  Created by Philipp on 11.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

class GFUserInfoHeaderViewController: UIViewController {
    
    @IBOutlet var avatarImageView : GFAvatarImageView!
    @IBOutlet var usernameLabel : GFTitleLabel!
    @IBOutlet var nameLabel : GFSecondaryTitleLabel!
    @IBOutlet var locationLabel : GFSecondaryTitleLabel!
    @IBOutlet var bioLabel : GFBodyLabel!
    
    var user: User!
    
    func set(user: User) {
        self.user = user
        configureUIElements()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
    
    func configureUIElements() {
        avatarImageView.downloadImage(fromUrl: user.avatarUrl)
        usernameLabel.text      = user.login
        nameLabel.text          = user.name ?? ""
        locationLabel.text      = user.location ?? "<No location>"
        bioLabel.text           = user.bio ?? ""
    }
        
    func layoutUI() {
        usernameLabel.set(textAlignment: .left, fontSize: 34)
        nameLabel.set(fontSize: 18)
        locationLabel.set(fontSize: 18)
        bioLabel.set(textAlignment: .left)
    }
}
