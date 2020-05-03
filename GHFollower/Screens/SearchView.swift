//
//  SearchView.swift
//  GHFollower
//
//  Created by Philipp on 03.05.20.
//  Copyright © 2020 Philipp. All rights reserved.
//

import SwiftUI

struct SearchView: View {

    @State private var alertContent: AlertContent?

    @State private var isEditing: Bool = false
    @State private var username: String = ""
    @State private var showingList: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Images.ghLogo
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding(.top, DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80)

                GFTextField("Enter a username",
                            text: $username,
                            isEditing: $isEditing,
                            onCommit: getFollowers)
                    .frame(height: 50)
                    .padding(.top, 40)
                    .padding(.horizontal, 50)

                GFButton(title: "Get Followers", backgroundColor: Color.green, action: getFollowers)
                    .frame(height: 50)
                    .padding(.top, 24)
                    .padding(.horizontal, 50)

                Spacer()

                NavigationLink(destination: FollowerListView(username: username), isActive: $showingList) {
                    EmptyView()
                }
            }
            .onAppear {
                self.username = "SAllen0400"
                self.showingList = false
            }
            .onTapGesture {
                print("Tapped")
                UIApplication.shared.endEditing()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .alert(item: $alertContent) { (content) -> Alert in
                Alert(title: Text(content.title),
                      message: Text(content.message),
                      dismissButton: .cancel(Text(content.buttonTitle)))
            }
        }
    }

    func getFollowers() {
        if username.isEmpty {
            alertContent = AlertContent(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😀.", buttonTitle: "OK")
            return
        }

        if isEditing {
            isEditing = false
            UIApplication.shared.endEditing()
        }

        print("Fetching followers for \(username)")
        self.showingList.toggle()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
