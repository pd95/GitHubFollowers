//
//  GFFollowerCell.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//
import SwiftUI

struct GFFollowerCell: View {
    let follower: Follower

    var body: some View {
        VStack {
            GFAvatarImage(url: follower.avatarUrl)
            GFTitleLabel(text: follower.login, textAlignment: .center, fontSize: 16)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

struct GFFollowerCell_Previews: PreviewProvider {
    static var previews: some View {
        GFFollowerCell(follower: Follower.examples[2])
            .frame(width: 100)
    }
}
