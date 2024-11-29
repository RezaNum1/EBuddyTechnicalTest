//
//  PasswordFieldLabel.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 29/11/24.
//

import SwiftUI

struct PasswordFieldLabel: View {
    var label: String
    @Binding var value: String

    var body: some View {
        SecureField("Password", text: $value)
            .foregroundColor(AppColor.inputLabel)
            .textFieldStyle(.roundedBorder)
            .padding(.bottom, 24)
            .foregroundColor(Color.white)
    }
}
