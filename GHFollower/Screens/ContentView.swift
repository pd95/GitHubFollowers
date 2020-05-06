//
//  ContentView.swift
//  GHFollower
//
//  Created by Philipp on 26.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView: View {

    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView()
                .tabItem {
                    SFSymbols.search
                        .font(.system(size: 24))
                    Text("Search")
                }
                .tag(0)
            FavoriteListView()
                .tabItem {
                    SFSymbols.favorites
                        .font(.system(size: 24))
                    Text("Favorites")
                }
                .tag(1)
        }
        .accentColor(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

