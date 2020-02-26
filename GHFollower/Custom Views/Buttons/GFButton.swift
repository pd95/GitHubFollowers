//
//  GFButton.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

@IBDesignable
class GFButton: UIButton {

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

    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        set(backgroundColor: backgroundColor, title: title)
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        setTitleColor(.white, for: .normal)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
}
