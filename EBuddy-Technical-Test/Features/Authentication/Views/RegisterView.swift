//
//  RegisterView.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authenticationVM: AuthenticationViewModel
    @State var name: String = ""
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

            TextFiledLabel(label: "Name", value: $name)

            TextFiledLabel(label: "Email", value: $email)

            TextFiledLabel(label: "Password", value: $password)

            TextFiledLabel(label: "Phone Number", value: $phoneNumber, keyboardType: .number)

            GenderPickerView(label: "Select Gender", value: $selectedGender)

            GeneralButton(action: {
                hideKeyboard()
                authenticationVM.register(user: UserJSON(name: name, email: email, phoneNumber: phoneNumber, gender: GenderEnum(rawValue: selectedGender)), password: password)
            }, label: "Sign up", isDisabled: !isFormFilled)
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
