//
//  LoginView.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authenticationVM: AuthenticationViewModel
    @EnvironmentObject var mainVM: MainViewModel

    @State var email: String = ""
    @State var password: String = ""

    var body: some View {
        VStack(spacing: 0){
            Spacer()
            Text("Welcome")
                .foregroundColor(Color.orange)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding(.bottom)

            if !authenticationVM.loginError.isEmpty {
                VStack(alignment: .leading, spacing: 0){
                    Text(authenticationVM.loginError)
                        .foregroundColor(Color.red)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding()
                }
            }

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 24)
                .foregroundColor(AppColor.inputLabel)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 24)
                .foregroundColor(AppColor.inputLabel)

            Button {
                mainVM.showLoader()
                hideKeyboard()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    authenticationVM.login(email: email, password: password)
                    mainVM.dismissLoader()
                })
            } label: {
                Text("Sign In")
                    .bold()
                    .foregroundColor(Color.white)
                    .frame(width: 200, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(isFormFilled ? Color.orange : Color.gray)
                    )
                    .disabled(!isFormFilled)
            }
            .disabled(!isFormFilled)
            .padding(.top)

            Button{
                self.authenticationVM.showRegisterPresenter.toggle()
            } label: {
                Text("Don't have an account? Register")
                    .bold()
                    .foregroundColor(.orange)
            }
            .padding(.top)
            Spacer()
        }
        .padding(.horizontal, 24)
        .onTapGesture {
            hideKeyboard()
        }
    }

    var isFormFilled: Bool {
        return email != "" && password != ""
    }
}
