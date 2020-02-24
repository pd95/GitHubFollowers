//
//  GFAlertViewController.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

class GFAlertViewController: UIViewController {
    
    @IBOutlet var containerView : GFContainerView!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var messageLabel : UILabel!
    @IBOutlet var actionButton : GFButton!

    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    

    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        set(title: title, message: message, buttonTitle: buttonTitle)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func set(title: String, message: String, buttonTitle: String) {
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI() {
        titleLabel.text = alertTitle ?? "Something went wrong"
        messageLabel.text = message ?? "Unable to complete request"
        actionButton.setTitle(buttonTitle ?? "OK", for: .normal)
    }
    
    @IBAction func dismissViewController() {
        dismiss(animated: true)
    }
}
