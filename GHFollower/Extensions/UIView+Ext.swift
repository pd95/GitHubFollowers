//
//  UIView+Ext.swift
//  GHFollower
//
//  Created by Philipp on 17.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}
