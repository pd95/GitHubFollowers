//
//  GFUserInfoHeaderView.swift
//  GHFollower
//
//  Created by Philipp on 05.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct GFUserInfoHeaderView: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                GFAvatarImage(url: user.avatarUrl)
                    .frame(width: 90)
                VStack(alignment: .leading) {
                    GFTitleLabel(text: user.login, textAlignment: .leading, fontSize: 34)
                    GFSecondaryTitleLabel(text: user.name ?? "", fontSize: 18)
                    HStack {
                        SFSymbols.location
                            .foregroundColor(.secondary)
                        GFSecondaryTitleLabel(text: user.location ?? "<No location>", fontSize: 18)
                    }
                }
            }
            GFBodyLabel(text: user.bio ?? "", textAlignment: .leading)
            Spacer()
        }
    }
}


struct GFUserInfoHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GFUserInfoHeaderView(user: User.example)
    }
}
