//
//  UserInfoView.swift
//  GHFollower
//
//  Created by Philipp on 04.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct UserInfoView: View {
    @Environment(\.presentationMode) var presentationMode

    let userName: String

    @State private var user: User!
    @State private var isLoading: Bool = true

    @State private var alertContent: AlertContent?

    var body: some View {
        NavigationView {
            Group {
                if !isLoading && user != nil {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            GFUserInfoHeaderView(user: self.user)

                            GFRepoItemView(user: self.user, profileAction: {})
                            GFFollowerItemView(user: self.user, followerAction: {})
                        }
                        .padding()
                    }
                }
            }
            .overlay(
                Group {
                    if isLoading {
                        ActivityIndicator(style: .large)
                            .frame(maxWidth: 120, maxHeight: 120)
                            .background(Color(.secondarySystemBackground).opacity(0.85))
                            .cornerRadius(10)
                    }
                }
                ,alignment: .center)
            .onAppear() {
                self.getUserInfo()
            }
            .alert(item: $alertContent) { (content) -> Alert in
                Alert(title: Text(content.title),
                      message: Text(content.message),
                      dismissButton: .cancel(Text(content.buttonTitle)))
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { self.presentationMode.wrappedValue.dismiss()}) {
                    Text("Done")
                        .bold()
                }
            )
        }
    }

    private func getUserInfo() {
        isLoading = true
        NetworkManager.shared.getUserInfo(for: userName) { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .failure(let error):
                        self.alertContent = AlertContent(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")

                    case .success(let user):
                        self.user = user
                }
                self.isLoading = false
            }
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(userName: Follower.examples[2].login)
    }
}
