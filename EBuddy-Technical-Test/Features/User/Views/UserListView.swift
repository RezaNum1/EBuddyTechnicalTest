//
//  UserListView.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 27/11/24.
//

import SwiftUI
import Firebase

struct UserListView: View {
    @EnvironmentObject var authenticationVM: AuthenticationViewModel
    @EnvironmentObject var userVM: UserViewModel

    @State var selectedUser: UserJSON? = nil
    @State var navigateToDetail: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 4){
                    ForEach(userVM.users, id: \.uid) { user in
                        CardthumView(user: user) {
                            selectedUser = user
                            navigateToDetail = true
                        }
                        Divider()
                    }
                    Text("Logout")
                        .onTapGesture {
                            authenticationVM.logOut()
                        }
                }
                .background(AppColor.basicBackround)
            }
            .onAppear {
                if userVM.users.isEmpty {
                    userVM.fetchUsers()
                }
            }
            .navigationDestination(isPresented: $navigateToDetail) {
                if let user = selectedUser {
                    DetailUserView(user: user)
                }
            }
        }
    }
}
