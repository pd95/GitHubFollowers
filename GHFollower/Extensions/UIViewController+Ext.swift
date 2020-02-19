//
//  UIViewController+Ext.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {

    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            // let alertVC = GFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            guard let alertVC = self.storyboard?.instantiateViewController(identifier: "Alert") as? GFAlertViewController /*, creator: { coder in
                return GFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            })*/ else {
                fatalError("Failed to load Alert from storyboard.")
            }

            alertVC.set(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentSafariViewController(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
