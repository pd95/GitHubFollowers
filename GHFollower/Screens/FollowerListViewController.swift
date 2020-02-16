//
//  FollowerListViewController.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import UIKit

class FollowerListViewController: UIViewController {

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

    var collectionView : UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section, Follower>!

    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureDataSource()
        getFollowers(username: username, page: 1)
        configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.dataSource = dataSource
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GFFollowerCell.self, forCellWithReuseIdentifier: GFFollowerCell.reuseID)
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func getFollowers(username: String, page: Int) {
        showGFLoadingScreen()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] (result) in
            guard let self = self else { return }
            self.dismissGFLoadingScreen()
            
            switch result {
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")

            case .success(let followers):
                self.hasMoreFollowers = followers.count == 100
                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty {
                    let message = "This user doen't have any followers. Go follow them 😃."
                    DispatchQueue.main.async {
                        self.showGFEmptyStateView(with: message, in: self.view)
                    }
                }
                else {
                    self.updateData(on: self.followers)
                }
            }
            self.isLoadingMoreFollowers = false
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
    
    @objc func addButtonTapped() {
        showGFLoadingScreen()

        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissGFLoadingScreen()
            
            switch result {
                case .success(let user):
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

                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
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
            isLoadingMoreFollowers = true
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destinationVC = UserInfoViewController()
        destinationVC.userName = follower.login
        destinationVC.delegate = self

        // present modally
        present(UINavigationController(rootViewController: destinationVC), animated: true)
    }
}

extension FollowerListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
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
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
