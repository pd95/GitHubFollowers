//
//  GFTitleLabel.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

@IBDesignable
class GFTitleLabel: UILabel {

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

    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        set(textAlignment: textAlignment, fontSize: fontSize)
    }
    
    func set(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.textAlignment = textAlignment
        if fontSize <= 16 {
            font = UIFont.preferredFont(forTextStyle: .headline)
            minimumScaleFactor = 0.5
            baselineAdjustment = .none
        }
        else if fontSize <= 18 {
            font = UIFont.preferredFont(forTextStyle: .title3)
            minimumScaleFactor = 0.75
            baselineAdjustment = .none
        }
        else if fontSize <= 26 {
            font = UIFont.preferredFont(forTextStyle: .title2)
        }
        else {
            font = UIFont.preferredFont(forTextStyle: .title1)
        }
    }
    
    private func configure() {
        font = UIFont.preferredFont(forTextStyle: .title1)
        textColor                         = .label
        adjustsFontSizeToFitWidth         = true
        minimumScaleFactor                = 0.9
        lineBreakMode                     = .byWordWrapping
    }
}
