//
//  AlertView.swift
//  GHFollower
//
//  Created by Philipp on 06.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI


struct AlertPreferenceKey: PreferenceKey {
    static var defaultValue: AlertContent?

    static func reduce(value: inout AlertContent?, nextValue: () -> AlertContent?) {
        // We keep only non-nil values
        let next = nextValue()
        if next != nil {
            value = next
        }
    }
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
        ZStack(alignment: .center) {

            self.presenting()
                .blur(radius: self.isShowing ? 2 : 0)

            VStack {
                VStack {
                    GFTitleLabel(text: self.content?.title ?? "", textAlignment: .center, fontSize: 20)

                    GFBodyLabel(text: self.content?.message ?? "", textAlignment: .center)
                        .padding()

                    GFButton(title: self.content?.buttonTitle ?? "", backgroundColor: Color(.systemPink),  action: self.dismiss)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .frame(maxWidth: 280)
                .cornerRadius(20)
                .shadow(radius: 15)
                .opacity(self.isShowing ? 1 : 0)
                .animation(Animation.easeOut(duration: 0.3).delay(0.3))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(self.isShowing ? [.all] : [])
            .background(Color.black.opacity(0.75))
            .animation(.easeIn(duration: 0.3))
            .opacity(self.isShowing ? 1 : 0)
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
