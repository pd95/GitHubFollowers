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
    @IBOutlet var titleLabel : GFTitleLabel!
    @IBOutlet var messageLabel : GFBodyLabel! = GFBodyLabel(textAlignment: .center)
    @IBOutlet var actionButton : GFButton!

    var alertTitle: String?
    var message: String?
    var buttonTitle: String?

    let padding: CGFloat = 20
    

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

        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }
    
    func configureTitleLabel() {
        titleLabel.set(textAlignment: .center, fontSize: 20)
        titleLabel.text = alertTitle ?? "Something went wrong"
    }

    func configureActionButton() {
        actionButton.set(backgroundColor: .systemPink, title: "OK")
        actionButton.setTitle(buttonTitle ?? "OK", for: .normal)
    }
    
    func configureMessageLabel() {
        messageLabel.set(textAlignment: .center)
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
    }
    
    @IBAction func dismissViewController() {
        dismiss(animated: true)
    }
}
