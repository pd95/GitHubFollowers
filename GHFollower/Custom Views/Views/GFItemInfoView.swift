//
//  GFItemInfoView.swift
//  GHFollower
//
//  Created by Philipp on 11.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

enum ItemInfoType {
    case repos, gists, followers, following
}

struct GFItemInfoView: View {

    let itemInfoType: ItemInfoType
    let count: Int

    let fontSize : CGFloat = 18

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            symbolImage
                .font(.system(size: fontSize))
                .padding(4)

            VStack(alignment: .center, spacing: 8) {
                GFTitleLabel(text: title, textAlignment: .leading, fontSize: fontSize)
                    .layoutPriority(1)

                GFTitleLabel(text: "\(count)", textAlignment: .center, fontSize: fontSize)
            }
        }
    }

    var symbolImage : Image {
        switch itemInfoType {
            case .repos:
                return SFSymbols.repos
            case .gists:
                return SFSymbols.gists
            case .followers:
                return SFSymbols.followers
            case .following:
                return SFSymbols.following
        }
    }

    var title : String {
        switch itemInfoType {
            case .repos:
                return "Public Repos"
            case .gists:
                return "Public Gists"
            case .followers:
                return "Followers"
            case .following:
                return "Following"
        }
    }
}

struct GFItemInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GFItemInfoView(itemInfoType: .repos, count: 123)
    }
}
