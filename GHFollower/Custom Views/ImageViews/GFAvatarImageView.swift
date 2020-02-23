//
//  GFAvatarImageView.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let placeholderImage = Images.placeholder
    var imageUrl: String!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
    }
    
    func downloadImage(fromUrl url: String) {
        imageUrl = url
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.imageUrl == url {
                    self.image = image
                }
            }
        }
    }
}
