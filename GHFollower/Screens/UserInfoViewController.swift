//
//  UserInfoViewController.swift
//  GHFollower
//
//  Created by Philipp on 11.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

protocol UserInfoViewControllerDelegate: class {
    func didRequestFollowers(for username: String)
}


class UserInfoViewController: GFDataLoadingViewController {
    
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var contentView : UIView!
    
    @IBOutlet var dateLabel : UILabel!

    @IBOutlet private var userInfoHeaderHeightConstraint: NSLayoutConstraint!
    private var userInfoHeaderVC : GFUserInfoHeaderViewController!
    private var repoItemVC : GFRepoItemViewController!
    private var followerItemVC : GFFollowerItemViewController!

    var userName : String!
    weak var delegate : UserInfoViewControllerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
    }

    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if (container as? GFUserInfoHeaderViewController) != nil {
            userInfoHeaderHeightConstraint.constant = container.preferredContentSize.height
        }
    }

    private func getUserInfo() {
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")

                case .success(let user):
                    DispatchQueue.main.async { self.configureUIElements(with: user) }
            }
            self.dismissLoadingView()
        }
    }
    
    private func configureUIElements(with user: User) {
        userInfoHeaderVC.set(user: user)
        repoItemVC.set(user: user)
        followerItemVC.set(user: user)
        dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }

    @IBAction private func dismissModal() {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed", let destVC = segue.destination as? GFUserInfoHeaderViewController {
            userInfoHeaderVC = destVC
        }
        else if segue.identifier == "embed", let destVC = segue.destination as? GFRepoItemViewController {
            destVC.delegate = self
            repoItemVC = destVC
        }
        else if segue.identifier == "embed", let destVC = segue.destination as? GFFollowerItemViewController {
            destVC.delegate = self
            followerItemVC = destVC
        }
    }
}


extension UserInfoViewController: GFRepoItemInfoViewControllerDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "OK")
            return
        }
        
        presentSafariViewController(with: url)
    }
}


extension UserInfoViewController: GFFollowerItemInfoViewControllerDelegate {
    func didTapGetFollowers(for user: User) {
        guard user.followers > 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers. What a shame 😢.", buttonTitle: "So sad")
            return
        }

        delegate.didRequestFollowers(for: user.login)
        dismissModal()
    }
}
