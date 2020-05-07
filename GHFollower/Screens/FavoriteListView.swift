//
//  FavoriteListView.swift
//  GHFollower
//
//  Created by Philipp on 03.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct FavoriteListView: View {
    @State private var favorites : [Follower] = []
    @State private var isLoading: Bool = true

    @State private var alertContent: AlertContent?

    var body: some View {
        NavigationView {
            Group {
                if !isLoading && favorites.isEmpty {
                    GFEmptyStateView(message: "No Favorites?\nAdd one on the\n Follower screen.")
                        .navigationBarTitle("Favorites")
                }
                else {
                    List {
                        ForEach(favorites) { favorite in
                            NavigationLink(destination: FollowerListView(username: favorite.login)) {
                                GFFavoriteCell(favorite: favorite)
                            }
                        }
                        .onDelete(perform: deleteFavorites)
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
                self.getFavorites()
            }
            .alert(content: $alertContent)
            .navigationBarTitle("Favorites")
        }
    }

    func getFavorites() {
        isLoading = true
        PersistenceManager.retrieveFavorites { result in
            switch result {
                case .failure(let error):
                    self.alertContent = AlertContent(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                case .success(let favorites):
                    self.favorites = favorites
            }
            self.isLoading = false
        }
    }

    func deleteFavorites(_ indexSet: IndexSet) {
        for index in indexSet {
            let favorite = favorites[index]

            PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { error in
                guard let error = error else {
                    self.favorites.remove(at: index)
                    return
                }
                self.alertContent = AlertContent(title: "Unable to remove", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
}

struct FavoriteListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteListView()
    }
}

