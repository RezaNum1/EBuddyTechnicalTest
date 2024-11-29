//
//  AuthenticationViewModel.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    @Published var showRegisterPresenter: Bool = false
    @Published var isUserLoggedIn: Bool = false
    let firestoreManager = FirestoreManager(collectionName: "USERS")

    @Published var registerError: String = ""
    @Published var loginError: String = ""

    init() {
//        let _ = Auth.auth().addStateDidChangeListener {  _, user in
//            if user != nil {
//                self.isUserLoggedIn.toggle()
//            }
//        }
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.loginError = error.localizedDescription
            } else {
                self?.loginError = ""
            }
        }
    }

    func register(user: UserJSON, password: String) {
        if let email = user.email,
           let phoneNumber = user.phoneNumber,
           let gender = user.gender,
           let name = user.name {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                if let error = error {
                    self?.registerError = error.localizedDescription
                } else {
                    self?.firestoreManager.insertDocument(data: ["name": name, "email": email, "phoneNumber": phoneNumber, "gender": gender.rawValue, "imageUrl": "", "lastActive": "", "price": 0.0, "rating": 0.0]) { errorStore in
                        if let errorStore = errorStore {
                            self?.registerError = errorStore.localizedDescription
                        } else {
                            self?.registerError = ""
                            self?.showRegisterPresenter = false
                        }
                    }
                }
            }
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            self.isUserLoggedIn = false
        } catch {
            print(error.localizedDescription)
        }
    }
}
