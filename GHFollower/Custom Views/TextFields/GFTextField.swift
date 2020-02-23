//
//  GFTextField.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

@IBDesignable
class GFTextField: UITextField {

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
        textColor       = .label
        tintColor       = .label
        textAlignment   = .center
        font            = UIFont.preferredFont(forTextStyle: .title2)
        minimumFontSize = 12
        adjustsFontSizeToFitWidth = true

        backgroundColor    = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType      = .go
        clearButtonMode    = .whileEditing
        placeholder        = "Enter a username"
    }
}
