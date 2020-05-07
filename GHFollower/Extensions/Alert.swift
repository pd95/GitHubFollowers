//
//  Alert.swift
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

extension Alert {
    init(content: AlertContent) {
        self.init(title: Text(content.title),
              message: Text(content.message),
              dismissButton: .cancel(Text(content.buttonTitle)))
    }
}

extension View {
    func alert(content: Binding<AlertContent?>) -> some View {
        return alert(item: content, content: { Alert(content: $0) })
    }
}
