//
//  GFEmptyStateView.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct GFEmptyStateView: View {
    let message: String

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                Images.emptyStateLogo
                    .resizable()
                    .frame(width: proxy.size.width * 1.3,
                           height: proxy.size.width * 1.3)
                    .offset(x: proxy.size.width * 1.3 / 5,
                            y: proxy.size.height - proxy.size.width * 1.3 + ( DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 120 : 80)
                )

                GFTitleLabel(text: self.message,
                             textAlignment: .center,
                             fontSize: 28)
                    .lineLimit(3)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 80)
                    .offset(x: 0, y: proxy.size.height / 2.0 - (DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 170 : 240))
            }
        }
    }
}

struct GFEmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationView {
                GFEmptyStateView(message: "No Favorites?\nAdd one on the\n Follower screen.")
                    .navigationBarTitle("Favorites")
            }
        }
    }
}
