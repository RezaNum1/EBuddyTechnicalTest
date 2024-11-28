//
//  Cardthum.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI

struct CardthumView: View {
    var user: UserJSON
    var onTapAction: () -> Void
    var body: some View {
        VStack(alignment: .leading){
            Text("\(user.email ?? "")")
                .font(.system(size: 25))
                .multilineTextAlignment(.leading)
                .padding([.top, .leading], 8)

            VStack(alignment: .leading, spacing: 4){
                Text("id: \(user.uid ?? "-")")
                Text("phone: \(user.phoneNumber ?? "-")")
                Text("gender: \(user.gender?.text ?? "-")")
            }
            .padding([.bottom, .leading], 8)
        }
        .cornerRadius(4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .border(Color.gray, width: 1)
        .padding(.horizontal, 16)
        .onTapGesture {
            onTapAction()
        }
    }
}
