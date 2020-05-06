//
//  AlertView.swift
//  GHFollower
//
//  Created by Philipp on 06.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct AlertContent: Identifiable {
    let id = UUID()

    let title: String
    let message: String
    let buttonTitle: String
}

extension View {
    func present(alert content: Binding<AlertContent?>) -> some View {
        AlertView(content: content, presenting: { self })
    }
}

struct AlertView<Presenting>: View where Presenting: View {

    @Binding var content: AlertContent?

    let presenting: () -> Presenting

    var isShowing : Bool { content != nil }

    var body: some View {
        self.presenting()
            .alert(item: $content) { (content) -> Alert in
                Alert(title: Text(content.title),
                      message: Text(content.message),
                      dismissButton: .cancel(Text(content.buttonTitle)))
            }
    }

    func dismiss() {
        content = nil
    }
}

struct AlertView_Previews: PreviewProvider {
    static var alert : AlertContent? = AlertContent(title: "Success!", message: "You have successfully favorited this user 🎉.", buttonTitle: "Hooray")
    static var previews: some View {
        VStack {
            Button("Press me") { }
        }
        .present(alert: .init(get: { self.alert }, set: { self.alert = $0 }))
    }
}
