//
//  GFItemInfoViewController.swift
//  GHFollower
//
//  Created by Philipp on 11.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

class GFItemInfoViewController: UIViewController {
    
    @IBOutlet var stackView : UIStackView!
    @IBOutlet var itemInfoViewOne : GFItemInfoView!
    @IBOutlet var itemInfoViewTwo : GFItemInfoView!
    @IBOutlet var actionButton : GFButton!

    var user: User!
    

    func set(user: User) {
        self.user = user
    }
    
    @IBAction func actionButtonTapped() {
    }
}
