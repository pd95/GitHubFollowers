//
//  GFDataLoadingViewController.swift
//  GHFollower
//
//  Created by Philipp on 17.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

class GFDataLoadingViewController: UIViewController {

    private var containerView: UIView!


    func showLoadingView() {
        if let collectionView = view as? UICollectionView {
            containerView = UIView(frame: collectionView.bounds)
        }
        else {
            containerView = UIView(frame: view.frame)
        }
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25, animations: { self.containerView.alpha = 0.75 })

        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
        
        activityIndicator.startAnimating()
    }

    func updateLoadingView() {
        guard containerView != nil else { return }
        if let collectionView = view as? UICollectionView {
            containerView.frame = collectionView.bounds
        }
        else {
            containerView.frame = view.frame
        }
    }

    func dismissLoadingView() {
        guard containerView != nil else { return }
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
