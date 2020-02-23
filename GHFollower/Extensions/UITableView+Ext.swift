//
//  UITableView+Ext.swift
//  GHFollower
//
//  Created by Philipp on 17.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

extension UITableView {

    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
