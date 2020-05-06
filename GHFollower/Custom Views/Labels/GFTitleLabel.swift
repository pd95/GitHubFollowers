//
//  GFTitleLabel.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct GFTitleLabel: View {
    let text: String
    let textAlignment: TextAlignment
    let fontSize : CGFloat

    var body: some View {
        Text(text)
            .font(
                Font.system(size: UIFontMetrics(forTextStyle: .title1).scaledValue(for: fontSize), weight: .bold)
            )
            .multilineTextAlignment(textAlignment)
    }
}

struct GFTitleLabel_Previews: PreviewProvider {
    static var previews: some View {
        List {
            GFTitleLabel(text: "Something went wrong",
                         textAlignment: .center,
                         fontSize: 20)

            GFTitleLabel(text: "SAllen0400",
                         textAlignment: .center,
                         fontSize: 26)
        }
    }
}
