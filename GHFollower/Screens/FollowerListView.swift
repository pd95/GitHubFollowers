//
//  FollowerListView.swift
//  GHFollower
//
//  Created by Philipp on 03.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    let space : CGFloat = 18.0

    var body: some View {
        VStack(spacing: space) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(alignment: .top, spacing: self.space) {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
        .padding(space)
    }
}


struct FollowerListView: View {
    let username: String

    @State private var followers = [Follower]()
    @State private var isLoadingMoreFollowers: Bool = false
    @State private var hasMoreFollowers: Bool = false
    @State private var page = 1

    @State private var filter: String = ""
    @State private var isSearching: Bool = false

    @State private var alertContent: AlertContent?

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

    var body: some View {
        Group {
            if followers.isEmpty {
                if isLoadingMoreFollowers {
                    Text("Loading...")
                }
                else {
                    GFEmptyStateView(message: "This user doesn't have any followers. Go follow them 😃.")
                }
            }
            else {
                VStack {
                    ScrollView {
                        SearchBar(placeholder: "Search for a username", searchText: $filter, isEditing: $isSearching)
                            .padding(.horizontal)
                        GridStack(rows: (filteredFollowers.count + 2) / 3, columns: 3) { row, col -> AnyView in
                            if row * 3 + col < self.filteredFollowers.count {
                                return AnyView(
                                    GFFollowerCell(follower: self.filteredFollowers[row * 3 + col])
                                        .frame(maxWidth: .infinity)
                                )
                            }
                            return AnyView(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.clear))
                        }
                        .id(UUID())
                    }
                }
            }
        }
        .onAppear() {
            if self.followers.isEmpty {
                self.getFollowers(username: self.username, page: self.page)
            }
        }
        .alert(item: $alertContent) { (content) -> Alert in
            Alert(title: Text(content.title),
                  message: Text(content.message),
                  dismissButton: .cancel(Text(content.buttonTitle)))
        }
        .navigationBarTitle(username)
        .navigationBarItems(trailing: Button(action: addButtonTapped) { SFSymbols.add }
            .font(.system(size: 24)))
    }

    private func getFollowers(username: String, page: Int) {
//        showLoadingView()
        isLoadingMoreFollowers = true

        NetworkManager.shared.getFollowers(for: username, page: page) { (result) in
//            self.dismissLoadingView()

            switch result {
                case .failure(let error):
                    self.alertContent = AlertContent(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")

                case .success(let followers):
//        let followers = Follower.examples
                    self.updateUI(with: followers)
            }
            self.isLoadingMoreFollowers = false
        }
    }

    private func updateUI(with followers: [Follower]) {
        DispatchQueue.main.async {
            self.hasMoreFollowers = followers.count == 100
            self.followers.append(contentsOf: followers)
        }
    }

    private func addButtonTapped() {
        print("addButtonTapped")
        //showLoadingView()

        NetworkManager.shared.getUserInfo(for: username) { result in
            //self.dismissLoadingView()

            switch result {
                case .success(let user):
                    self.addUserToFavorites(user: user)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.alertContent = AlertContent(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                }
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
