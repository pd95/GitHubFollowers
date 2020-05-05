//
//  GFFollowerItemView.swift
//  GHFollower
//
//  Created by Philipp on 05.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct GFFollowerItemView: View {
    let user: User
    let followerAction: GFButton.ButtonAction

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                GFItemInfoView(itemInfoType: .followers, count: user.followers)
                    .frame(maxWidth: .infinity)

                GFItemInfoView(itemInfoType: .following, count: user.following)
                    .frame(maxWidth: .infinity)
            }

            GFButton(title: "Get Followers", backgroundColor: .green, action: followerAction)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(18)
    }
}

struct GFFollowerItemView_Previews: PreviewProvider {
    static var previews: some View {
        GFFollowerItemView(user: User.example, followerAction: {})
    }
}
