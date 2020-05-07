//
//  FollowerListView.swift
//  GHFollower
//
//  Created by Philipp on 03.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

extension String: Identifiable {
    public var id: Self { self }
}

struct FollowerListView: View {
    let username: String

    @State private var followers = [Follower]()
    @State private var isLoading: Bool = true
    @State private var hasMoreFollowers: Bool = false
    @State private var page = 1

    @State private var filter: String = ""
    @State private var isSearching: Bool = false

    @State private var alertContent: AlertContent?
    @State private var selectedFollower: Follower?

    @State private var selectedUserName: String?
    private var customNavigationBinding: Binding<Bool> {
        Binding(get: { () -> Bool in
            self.selectedUserName != nil
        }, set: { (active) in
            if !active {
                self.selectedUserName = nil
            }
        })
    }

    init(username: String) {
        self.username = username
    }

    var filteredFollowers: [Follower] {
        if isSearching && !filter.isEmpty {
            let lowerFilter = filter.lowercased()
            return followers.filter {
                $0.login.lowercased().contains(lowerFilter)
            }
        }
        return followers
    }

    var filteredFollowersRows: Int {
        (filteredFollowers.count + 2) / 3
    }

    var body: some View {
        Group {
            if !isLoading && followers.isEmpty {
                GFEmptyStateView(message: "This user doesn't have any followers. Go follow them 😃.")
            }
            else {
                if self.selectedUserName != nil {
                    NavigationLink(destination: FollowerListView(username: self.selectedUserName ?? ""), isActive: customNavigationBinding) {
                        EmptyView()
                    }
                }

                List {
                    SearchBar(placeholder: "Search for a username", searchText: $filter, isEditing: $isSearching)

                    ForEach(0..<self.filteredFollowersRows, id: \.self) { row in
                        HStack(alignment: .top, spacing: 18) {
                            ForEach(0..<3, id: \.self) { col -> AnyView in
                                if row * 3 + col < self.filteredFollowers.count {
                                    return AnyView(
                                        GFFollowerCell(follower: self.filteredFollowers[row * 3 + col])
                                            .frame(maxWidth: .infinity)
                                            .onTapGesture {
                                                self.selectedFollower = self.filteredFollowers[row * 3 + col]

                                            }
                                    )
                                }

                                // A rectangle to fill the available space "invisibly"
                                return AnyView(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color.clear)
                                )
                            }
                        }
                        // Invalidate view IDs while searching
                        .id(self.isSearching ? UUID() : nil)
                    }
                    .listStyle(PlainListStyle())

                    // Add a row to fetch more content
                    if self.hasMoreFollowers {
                        Rectangle()
                            .fill(Color.clear)
                            .onAppear() {
                                self.page += 1
                                self.getFollowers(username: self.username, page: self.page)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .overlay(
            Group {
                if isLoading {
                    ActivityIndicator(style: .large)
                        .frame(width: 120, height: 120)
                        .background(Color(.secondarySystemBackground).opacity(0.75))
                        .cornerRadius(10)
                }
            }
            ,alignment: .center)
        .onAppear() {
            if self.followers.isEmpty {
                self.getFollowers(username: self.username, page: self.page)
            }
        }
        .alert(content: $alertContent)
        .sheet(item: $selectedFollower, content: { (follower) in
            UserInfoView(userName: follower.login, selectedUserName: self.$selectedUserName)
        })
        .navigationBarTitle(username)
        .navigationBarItems(trailing: Button(action: addButtonTapped) { SFSymbols.add }
            .font(.system(size: 24)))
    }

    private func getFollowers(username: String, page: Int) {
        isLoading = true

        NetworkManager.shared.getFollowers(for: username, page: page) { (result) in

            switch result {
                case .failure(let error):
                    self.alertContent = AlertContent(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")

                case .success(let followers):
                    self.updateUI(with: followers)
            }
            self.isLoading = false
        }
    }

    private func updateUI(with followers: [Follower]) {
        DispatchQueue.main.async {
            self.hasMoreFollowers = followers.count == 100
            self.followers.append(contentsOf: followers)
        }
    }

    private func addButtonTapped() {
        isLoading = true

        NetworkManager.shared.getUserInfo(for: username) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let user):
                        self.addUserToFavorites(user: user)
                    case .failure(let error):
                        self.alertContent = AlertContent(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                }
                self.isLoading = false
            }
        }
    }

    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateWith(favorite: favorite, actionType: .add, completed: { error in
            if let error = error {
                self.alertContent = AlertContent(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
            else {
                self.alertContent = AlertContent(title: "Success!", message: "You have successfully favorited this user 🎉.", buttonTitle: "Hooray")
            }
        })
    }
}

struct FollowerListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FollowerListView(username: "SAllen0400")
        }
    }
}
