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
    @State var users: [UserJSON] = []
    @State var selectedUser: UserJSON? = nil
    @State var navigateToDetail: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 4){
                    ForEach(users, id: \.uid) { user in
                        CardthumView(user: user) {
                            selectedUser = user
                            navigateToDetail = true
                        }
                    }
                    Text("Logout")
                        .onTapGesture {
                            authenticationVM.logOut()
                        }
                }
            }
            .onAppear {
                fetchData()
            }
            .navigationDestination(isPresented: $navigateToDetail) {
                if let user = selectedUser {
                    DetailUserView(user: user)
                }
            }
        }
    }

    func fetchData() {
        let firestoreManager = FirestoreManager(collectionName: "USERS")

        users.removeAll()

        firestoreManager.fetchDocuments { documents, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }

            for document in documents {
                let data = document.data()

                let id = document.documentID
                let email = data["email"] as? String ?? ""
                let gender = data["gender"] as? Int ?? 0
                let phoneNumber = data["phoneNumber"] as? String ?? ""
                let imageUrl = data["imageUrl"] as? String ?? ""

                self.users.append(
                    UserJSON(
                        uid: id,
                        email: email,
                        phoneNumber: phoneNumber,
                        gender: GenderEnum(rawValue: gender),
                        imageUrl: imageUrl
                    )
                )
            }
        }
    }
}
