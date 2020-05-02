//
//  FollowerListViewController.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

class FollowerListViewController: GFDataLoadingViewController {

    enum Section {
        case main
    }
    
    var username : String!
    var followers = [Follower]()
    var filteredFollowers = [Follower]()
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false

    @IBOutlet var collectionView : UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section, Follower>!
    var searchController : UISearchController!


    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = username
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = UIHelper.createThreeColumnFlowLayout(in: collectionView)
    }
    
    private func configureSearchController() {
        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true

        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] (result) in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")
                
                case .success(let followers):
                    self.updateUI(with: followers)
            }
            self.isLoadingMoreFollowers = false
        }
    }
    
    func updateUI(with followers: [Follower]) {
        hasMoreFollowers = followers.count == 100
        self.followers.append(contentsOf: followers)
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😃."
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message, in: self.view)
            }
        }
        else {
            updateData(on: self.followers)
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GFFollowerCell.reuseID, for: indexPath) as! GFFollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @IBAction @objc func addButtonTapped() {
        showLoadingView()

        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
                case .success(let user):
                    self.addUserToFavorites(user: user)
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateWith(favorite: favorite, actionType: .add, completed: { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
            else {
                self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user 🎉.", buttonTitle: "Hooray")
            }
        })

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUser", let follower = sender as? Follower,
            let destinationNC = segue.destination as? UINavigationController,
            let destinationVC = destinationNC.viewControllers.first as? UserInfoViewController {
            destinationVC.userName = follower.login
            destinationVC.delegate = self
        }
    }
}


extension FollowerListViewController: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isLoadingMoreFollowers {
            updateLoadingView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        performSegue(withIdentifier: "showUser", sender: follower)
    }
}


extension FollowerListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            isSearching = false
            filteredFollowers.removeAll()
            updateData(on: followers)
            return
        }
        isSearching = true
        filteredFollowers = followers.filter {
            $0.login.lowercased().contains(filter)
        }
        updateData(on: filteredFollowers)
    }
}


extension FollowerListViewController: UserInfoViewControllerDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1

        if isSearching {
            isSearching = false
            searchController.isActive = false
        }
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
