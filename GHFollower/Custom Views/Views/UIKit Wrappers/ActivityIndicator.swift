//
//  ActivityIndicator.swift
//  GHFollower
//
//  Created by Philipp on 04.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    let style : UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.startAnimating()
        return activityIndicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    }

    typealias UIViewType = UIActivityIndicatorView

}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(style: .large)
    }
}
