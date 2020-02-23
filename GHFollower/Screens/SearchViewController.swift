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
    @IBOutlet var usernameTextField : GFTextField!
    @IBOutlet var callToActionButton : GFButton!
    
    var isUsernameEntered: Bool {
        return !usernameTextField.text!.isEmpty
    }


    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "getFollowers" {
            if !isUsernameEntered {
                presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😀.", buttonTitle: "OK")
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getFollowers",
            let destinationVC = segue.destination as? FollowerListViewController {
            destinationVC.username = usernameTextField.text
        }
        usernameTextField.resignFirstResponder()
    }
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if shouldPerformSegue(withIdentifier: "getFollowers", sender: nil) {
            performSegue(withIdentifier: "getFollowers", sender: nil)
        }
        return true
    }
}
