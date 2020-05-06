//
//  GFSecondaryTitleLabel.swift
//  GHFollower
//
//  Created by Philipp on 11.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct GFSecondaryTitleLabel: View {
    let text: String
    let fontSize : CGFloat

    var body: some View {
        Text(text)
            .font(
                Font.system(size: UIFontMetrics(forTextStyle: .title3).scaledValue(for: fontSize), weight: .medium)
            )
            .foregroundColor(.secondary)
    }
}

struct GFSecondaryTitleLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GFSecondaryTitleLabel(text: "SAllen0400",
                         fontSize: 18)
        }
    }
}
