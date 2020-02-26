//
//  GFUserInfoHeaderViewController.swift
//  GHFollower
//
//  Created by Philipp on 11.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

class GFUserInfoHeaderViewController: UIViewController {
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet var avatarImageView : GFAvatarImageView!
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var locationLabel : UILabel!
    @IBOutlet var bioLabel : UILabel!
    
    var user: User!
    
    func set(user: User) {
        self.user = user
        configureUIElements()
    }
    
    func configureUIElements() {
        avatarImageView.downloadImage(fromUrl: user.avatarUrl)
        usernameLabel.text      = user.login
        nameLabel.text          = user.name ?? ""
        locationLabel.text      = user.location ?? "<No location>"
        bioLabel.text           = user.bio ?? ""
    }
    
    private func calculatePreferredSize() {
        let targetSize = CGSize(width: view.bounds.width,
            height: UIView.layoutFittingCompressedSize.height)
        preferredContentSize = topStackView.systemLayoutSizeFitting(targetSize)
    }

    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      calculatePreferredSize()
    }
}
