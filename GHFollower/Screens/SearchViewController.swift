//
//  SearchViewController.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet var logoImageView : UIImageView!
    @IBOutlet var usernameTextField : UITextField!
    @IBOutlet var callToActionButton : UIButton!
    
    var isUsernameEntered: Bool {
        return !usernameTextField.text!.isEmpty
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        usernameTextField.text = ""
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowerListViewController() {
        guard isUsernameEntered else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😀.", buttonTitle: "OK")
            return
        }
        
        usernameTextField.resignFirstResponder()
        
        let followerListVC = FollowerListViewController(username: usernameTextField.text!)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
        
    func configureTextField() {
        usernameTextField.delegate = self
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.layer.borderWidth  = 2
        usernameTextField.layer.borderColor  = UIColor.systemGray4.cgColor
    }
    
    func configureCallToActionButton() {
        callToActionButton.layer.cornerRadius = 10
        callToActionButton.addTarget(self, action: #selector(pushFollowerListViewController), for: .touchUpInside)
    }
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListViewController()
        return true
    }
}
