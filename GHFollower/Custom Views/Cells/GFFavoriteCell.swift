//
//  GFFavoriteCell.swift
//  GHFollower
//
//  Created by Philipp on 15.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//
import SwiftUI

struct GFFavoriteCell: View {
    let favorite: Follower

    var body: some View {
        HStack {
            GFAvatarImage(url: favorite.avatarUrl)
                .frame(width: 60, height: 60, alignment: .center)
            GFTitleLabel(text: favorite.login, textAlignment: .leading, fontSize: 26)
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(1)
        }
    }
}

struct GFFavoriteCell_Previews: PreviewProvider {
    static var previews: some View {
        GFFavoriteCell(favorite: Follower.examples[2])
            .frame(width: 300)
    }
}
