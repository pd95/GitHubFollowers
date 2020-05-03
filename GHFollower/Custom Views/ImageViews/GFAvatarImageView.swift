//
//  GFAvatarImageView.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//
import SwiftUI

struct GFAvatarImage: View {
    let url: String

    @State var image : Image = Images.placeholder

    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
            .onAppear() {
                self.downloadImage()
            }
    }

    func downloadImage() {
        NetworkManager.shared.downloadImage(from: url) { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.image = Image(uiImage: image)
                }
            }
        }
    }
}

struct GFAvatarImageView_Previews: PreviewProvider {
    static var previews: some View {
        GFAvatarImage(url: "https://avatars0.githubusercontent.com/u/8109229?v=4")
            .frame(width: 100)
    }
}
