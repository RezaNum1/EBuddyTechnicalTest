//
//  TextFiledLabel.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI

struct TextFiledLabel: View {
    var label: String
    @Binding var value: String
    var keyboardType: KeyboardType = .text

    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text(label)
                .bold()
                .font(.system(size: 18))
                .padding(.bottom, 2)

            if keyboardType == .text {
                TextField(label, text: $value)
                    .foregroundColor(AppColor.inputLabel)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 20)
            } else if keyboardType == .number {
                TextField(label, text: $value)
                    .foregroundColor(AppColor.inputLabel)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .padding(.bottom, 20)
            } else if keyboardType == .decimal {
                TextField(label, text: $value)
                    .foregroundColor(AppColor.inputLabel)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .padding(.bottom, 20)
            }
        }
    }
    enum KeyboardType {
        case text
        case number
        case decimal
    }
}
