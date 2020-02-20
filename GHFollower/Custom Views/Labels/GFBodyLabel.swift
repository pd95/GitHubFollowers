//
//  GFBodyLabel.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

@IBDesignable
class GFBodyLabel: UILabel {

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

    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        set(textAlignment: textAlignment)
    }
    
    func set(textAlignment: NSTextAlignment) {
        self.textAlignment = textAlignment
    }
    
    private func configure() {
        textColor                         = .secondaryLabel
        font                              = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth         = true
        adjustsFontForContentSizeCategory = true
        minimumScaleFactor                = 0.75
        lineBreakMode                     = .byWordWrapping
    }
}
