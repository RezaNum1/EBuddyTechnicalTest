//
//  PickImageView.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI

struct PickImageView: View {
    var onTap: () -> Void
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
                .cornerRadius(10)
            VStack {
                Image("photos")
                    .resizable()
                    .frame(width: 100, height: 80)
                HStack {
                    Text("Choose your photo")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(Color.white)
                }
            }
        }
        .padding(.bottom, 20)
        .frame(width: 350, height: 400)
        .onTapGesture {
            onTap()
        }
    }
}
