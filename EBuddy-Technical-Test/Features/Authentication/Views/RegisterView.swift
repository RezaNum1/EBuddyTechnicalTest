//
//  RegisterView.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authenticationVM: AuthenticationViewModel
    @State var email: String = ""
    @State var password: String = ""
    @State var phoneNumber: String = ""
    @State var selectedGender: Int = 99
    @State var showPicker: Bool = false
    var genders: [String] = ["Male", "Female"]

    var body: some View {
        VStack(spacing: 0){
            Spacer()

            Text("Register")
                .foregroundColor(Color.orange)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding(.bottom)

            if !authenticationVM.registerError.isEmpty {
                VStack(alignment: .leading, spacing: 0){
                    Text(authenticationVM.registerError)
                        .foregroundColor(Color.red)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding()
                }
            }

            TextField("Email", text: $email)
                .foregroundColor(.black)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 24)

            SecureField("Password", text: $password)
                .foregroundColor(.black)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 24)

            TextField("Phone Number", text: $phoneNumber)
                .foregroundColor(.black)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .padding(.bottom, 24)

            HStack {
                Text("Select Gender")
                    .foregroundColor(.gray)
                Picker("", selection: $selectedGender) {
                    Text("Male").tag(1).font(.title)
                    Text("Female").tag(0).font(.title)
                }.pickerStyle(SegmentedPickerStyle())
            }

            Button {
                hideKeyboard()
                authenticationVM.register(user: UserJSON(email: email, phoneNumber: phoneNumber, gender: GenderEnum(rawValue: selectedGender)), password: password)
            } label: {
                Text("Sign up")
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
            Spacer()
        }
        .padding(.horizontal, 24)
        .onTapGesture {
            hideKeyboard()
        }
    }

    var isFormFilled: Bool {
        return email != "" && password != "" && phoneNumber != "" && selectedGender != 99
    }
}
