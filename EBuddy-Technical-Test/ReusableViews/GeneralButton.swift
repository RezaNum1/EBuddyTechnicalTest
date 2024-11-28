//
//  GeneralButton.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI

struct GeneralButton: View {
    let action: () -> Void
    let label: String
    var isDisabled: Bool

    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .bold()
                .foregroundColor(Color.white)
                .frame(width: 200, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isDisabled ? Color.gray : Color.orange)
                )
        }
        .disabled(isDisabled)
    }
}
