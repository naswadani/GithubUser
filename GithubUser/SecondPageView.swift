//
//  SecondPageView.swift
//  GithubUser
//
//  Created by naswakhansa on 22/07/23.
//

import SwiftUI

struct SecondPageView: View {
    @Binding var user: [User]

    var body: some View {
        List(user, id: \.login) { user in
            VStack(alignment: .leading) {
                Text(user.login)
                    .font(.headline)
                Text(user.url)
                    .font(.subheadline)
            }
        }
        .navigationTitle("Destination View")
        .navigationBarTitleDisplayMode(.inline)
    }
}
//let apicall = apiCall()
//apicall.getUsers(username:textfill){users in
//    if let users = users {
//        print("User data received:")
//        for user in users {
//            print("Username: \(user.login)")
//            print("User Url: \(user.url)")
//        }
//    } else {
//        print("Failed to fetch user data.")
//    }
//}
