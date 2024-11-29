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
    @EnvironmentObject var mainVM: MainViewModel

    @State var selectedUser: UserJSON? = nil
    @State var navigateToDetail: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                HStack(spacing: 8){
                    Button {
                        self.userVM.sortUsers(loader: $mainVM.isLoading)
                    } label: {
                        HStack {
                            Text("Sort")
                                .font(.system(size: 18))
                                .foregroundColor(AppColor.inputLabel)

                            Image(systemName: "list.bullet.below.rectangle")
                                .foregroundColor(AppColor.inputLabel)
                        }
                        .frame(width: 100, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.gray.opacity(0.4))
                        )
                    }

                    Spacer()

                    Button {
                        authenticationVM.logOut()
                    } label: {
                        HStack {
                            Text("Logout")
                                .font(.system(size: 18))
                                .foregroundColor(AppColor.inputLabel)

                            Image(systemName: "iphone.and.arrow.forward.outward")
                                .foregroundColor(AppColor.inputLabel)
                        }
                        .frame(width: 120, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.gray.opacity(0.4))
                        )
                    }
                }
                .padding(.horizontal, 16)

                VStack(spacing: 4){
                    ForEach(userVM.users, id: \.uid) { user in
                        CardthumView(user: user) {
                            selectedUser = user
                            navigateToDetail = true
                        }
                        Divider()
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
