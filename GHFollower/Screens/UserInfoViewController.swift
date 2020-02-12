//
//  UserInfoViewController.swift
//  GHFollower
//
//  Created by Philipp on 11.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    
    var itemViews: [UIView] = []
    
    var userName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        layoutUI()

        getUserInfo()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModal))
        navigationItem.rightBarButtonItem = doneButton
    }

    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")

                case .success(let user):
                    DispatchQueue.main.async {
                        self.add(childVC: GFUserInfoHeaderViewController(user: user), to: self.headerView)
                        self.add(childVC: GFRepoItemViewController(user: user), to: self.itemViewOne)
                        self.add(childVC: GFFollowerItemViewController(user: user), to: self.itemViewTwo)
                    }
            }
        }
    }

    private func layoutUI() {
        
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        headerView.backgroundColor = .systemBackground
        itemViewOne.backgroundColor = .systemBackground
        itemViewTwo.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
        
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
        ])
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
}
