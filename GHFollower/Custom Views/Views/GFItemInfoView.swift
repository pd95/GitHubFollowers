//
//  GFItemInfoView.swift
//  GHFollower
//
//  Created by Philipp on 11.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

enum ItemInfoType: Int {
    case repos, gists, followers, following
}


@IBDesignable
class GFItemInfoView: UIView {
    
    var infoType: ItemInfoType = .repos
    @IBInspectable var itemInfoType: Int {
        get { infoType.rawValue }
        set {
            if let valid = ItemInfoType(rawValue: newValue) {
                infoType = valid
            }
        }
    }
    @IBInspectable var count: Int = 0 {
        didSet {
            set(itemInfoType: infoType, withCount: count)
        }
    }

    let symbolImageView = UIImageView()
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)

    
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
        addSubviews(symbolImageView, titleLabel, countLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFit
        symbolImageView.preferredSymbolConfiguration = .init(textStyle: .body, scale: .small)
        symbolImageView.tintColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding : CGFloat = 4
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            symbolImageView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            symbolImageView.widthAnchor.constraint(equalTo: symbolImageView.heightAnchor),

            symbolImageView.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            countLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: titleLabel.lastBaselineAnchor, multiplier: 1.2),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -padding),
        ])
    }
    
    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
            case .repos:
                symbolImageView.image = SFSymbols.repos
                titleLabel.text = "Public Repos"
            case .gists:
                symbolImageView.image = SFSymbols.gists
                titleLabel.text = "Public Gists"
            case .followers:
                symbolImageView.image = SFSymbols.followers
                titleLabel.text = "Followers"
            case .following:
                symbolImageView.image = SFSymbols.following
                titleLabel.text = "Following"
        }
        countLabel.text = String(count)
    }
}
