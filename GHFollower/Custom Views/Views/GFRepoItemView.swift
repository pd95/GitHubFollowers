//
//  GFRepoItemView.swift
//  GHFollower
//
//  Created by Philipp on 05.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct GFRepoItemView: View {
    let user: User
    let profileAction: GFButton.ButtonAction

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 0) {
                GFItemInfoView(itemInfoType: .repos, count: user.publicRepos)
                    .frame(maxWidth: .infinity)

                GFItemInfoView(itemInfoType: .gists, count: user.publicGists)
                    .frame(maxWidth: .infinity)
            }

            GFButton(title: "GitHub Profile", backgroundColor: .purple, action: profileAction)
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(18)
    }
}

struct GFRepoItemView_Previews: PreviewProvider {
    static var previews: some View {
        GFRepoItemView(user: User.example, profileAction: {})
            .padding()
    }
}
