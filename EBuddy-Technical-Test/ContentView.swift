//
//  ContentView.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 27/11/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authenticationVM: AuthenticationViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var userVM: UserViewModel

    var body: some View {
        ZStack {
            if self.authenticationVM.isUserLoggedIn {
                UserListView()
            } else {
                LoginView()
            }

            if mainVM.isLoading {
                ZStack {
                    Color.orange.opacity(0.1)
                        .ignoresSafeArea()
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .disabled(true)
            }
        }
        .sheet(isPresented: $authenticationVM.showRegisterPresenter, content: {
            RegisterView()
        })
        .onAppear {
            let _ = Auth.auth().addStateDidChangeListener {  _, user in
                if user != nil {
                    self.authenticationVM.isUserLoggedIn.toggle()
                    self.userVM.users.removeAll()
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
