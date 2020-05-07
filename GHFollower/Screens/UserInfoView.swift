//
//  UserInfoView.swift
//  GHFollower
//
//  Created by Philipp on 04.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

extension URL: Identifiable {
    public var id: Self { self }
}

struct UserInfoView: View {
    @Environment(\.presentationMode) var presentationMode

    let userName: String

    @Binding var selectedUserName: String?

    @State private var user: User!
    @State private var isLoading: Bool = true

    @State private var alertContent: AlertContent?
    @State private var linkURL: URL?

    var body: some View {
        NavigationView {
            Group {
                if !isLoading && user != nil {
                    Group {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                GFUserInfoHeaderView(user: self.user)

                                GFRepoItemView(user: self.user, profileAction: didTapGitHubProfile)
                                GFFollowerItemView(user: self.user, followerAction: didTapGetFollowers)

                                GFBodyLabel(text: "GitHub since \(user.createdAt.convertToMonthYearFormat())", textAlignment: .center)
                                    .frame(maxWidth: .infinity)
                            }
                            .padding()
                        }
                    }
                }
            }
            .overlay(
                Group {
                    if isLoading {
                        ActivityIndicator(style: .large)
                            .frame(width: 120, height: 120)
                            .background(Color(.secondarySystemBackground).opacity(0.75))
                            .cornerRadius(10)
                    }
                }
                ,alignment: .center)
            .present(alert: $alertContent)
            .onAppear() {
                self.getUserInfo()
            }
            .sheet(item: self.$linkURL, content: { (url) in
                SafariView(url: url)
            })
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { self.presentationMode.wrappedValue.dismiss()}) {
                    Text("Done")
                        .bold()
                        .padding(6)
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

    func didTapGitHubProfile() {
        guard let url = URL(string: user.htmlUrl) else {
            alertContent = AlertContent(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "OK")
            return
        }

        linkURL = url
    }

    func didTapGetFollowers() {
        guard user.followers > 0 else {
            alertContent = AlertContent(title: "No followers", message: "This user has no followers. What a shame 😢.", buttonTitle: "So sad")
            return
        }

        selectedUserName = user.login

        presentationMode.wrappedValue.dismiss()
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(userName: Follower.examples[2].login, selectedUserName: .constant(""))
    }
}
