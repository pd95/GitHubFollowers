//
//  GFButton.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct GFButton: View {
    typealias ButtonAction = ()->Void

    let title: String
    let backgroundColor: Color

    let action: ButtonAction

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color.white)
                .padding(14)
                .frame(maxWidth: .infinity)
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct GFButton_Previews: PreviewProvider {
    static var previews: some View {
        GFButton(title: "Get Followers", backgroundColor: Color.green, action: { print("Button pressed")})
    }
}
