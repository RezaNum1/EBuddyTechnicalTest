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
    var textKeyboard: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text(label)
                .bold()
                .font(.system(size: 18))
                .padding(.bottom, 2)

            if textKeyboard {
                TextField(label, text: $value)
                    .foregroundColor(.black)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 20)
            } else {
                TextField(label, text: $value)
                    .foregroundColor(.black)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .padding(.bottom, 20)
            }

        }
    }
}
