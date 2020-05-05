//
//  SafariView.swift
//  GHFollower
//
//  Created by Philipp on 05.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {

    typealias UIViewControllerType = SFSafariViewController

    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        return safariVC
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://google.com")!)
    }
}
