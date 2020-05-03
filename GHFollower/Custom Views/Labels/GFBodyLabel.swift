//
//  GFBodyLabel.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct GFBodyLabel: View {
    let text: String
    let textAlignment: TextAlignment

    var body: some View {
        Text(text)
            .font(Font.body)
            .multilineTextAlignment(textAlignment)
            .foregroundColor(.secondary)
    }
}

struct GFBodyLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GFBodyLabel(text: "Something about me",
                         textAlignment: .leading)
        }
    }
}
