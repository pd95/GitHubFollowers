//
//  GFSecondaryTitleLabel.swift
//  GHFollower
//
//  Created by Philipp on 11.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

@IBDesignable
class GFSecondaryTitleLabel: UILabel {

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

    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        set(fontSize: fontSize)
    }
    
    func set(fontSize: CGFloat) {
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    private func configure() {
        textColor                 = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor        = 0.90
        lineBreakMode             = .byTruncatingTail
    }
}
