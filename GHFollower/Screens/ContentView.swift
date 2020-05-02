//
//  ContentView.swift
//  GHFollower
//
//  Created by Philipp on 26.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct AlertContent: Identifiable {
    let id = UUID()

    let title: String
    let message: String
    let buttonTitle: String
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView: View {

    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .font(Font.title)
                    Text("Search")
                }
            FavoriteListView()
                .tabItem {
                    Image(systemName: "star.fill")
                        .font(Font.title)
                    Text("Favorites")
                }
        }
        .accentColor(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

