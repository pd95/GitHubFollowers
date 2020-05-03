//
//  FavoriteListView.swift
//  GHFollower
//
//  Created by Philipp on 03.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct FavoriteListView: View {
    var body: some View {
        NavigationView {
            GFEmptyStateView(message: "No Favorites?\nAdd one on the\n Follower screen.")
                .navigationBarTitle("Favorites")
        }
    }
}

struct FavoriteListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteListView()
    }
}

