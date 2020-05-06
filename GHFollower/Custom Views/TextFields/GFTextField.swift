//
//  GFTextField.swift
//  GHFollower
//
//  Created by Philipp on 10.02.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct GFTextField: View {
    typealias commitFunc = (() -> Void)

    let placeholder: String
    let onCommit: commitFunc?

    @Binding var text: String

    @Binding var isEditing: Bool

    init(_ placeholder: String, text: Binding<String>, isEditing: Binding<Bool>, onCommit: commitFunc? = nil) {
        self.placeholder = placeholder
        self._text = text
        self._isEditing = isEditing
        self.onCommit = onCommit
    }

    var body: some View {
        TextField(placeholder, text: $text, onCommit: {
            self.isEditing = false
            UIApplication.shared.endEditing()
            self.onCommit?()
        })
            .multilineTextAlignment(.center)
            .font(Font.system(size: UIFontMetrics(forTextStyle: .title2).scaledValue(for: 22)))
            .keyboardType(.asciiCapable)
            .padding(12)
            .overlay(
                Group {
                    if /*isEditing && */!text.isEmpty {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(.tertiaryLabel))
                        }
                        .padding(6)
                        .padding(.trailing, 4)
                        .accessibility(label: Text("Clear"))
                        .accessibility(identifier: "clearButton")
                    }
                },
                alignment: .trailing
            )
            .background(
                Color(.tertiarySystemBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color(.systemGray4), lineWidth: 2)
                )
            )
            .onTapGesture {
                self.isEditing = true
            }
    }
}

struct GFTextField_Previews: PreviewProvider {
    static var previews: some View {
        GFTextField("Enter a username",
                    text: .constant("Sallen0400"),
                    isEditing: .constant(true),
                    onCommit: { print("Enter pressed")})
    }
}
