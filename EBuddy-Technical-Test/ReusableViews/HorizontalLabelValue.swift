//
//  HorizontalLabelValue.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI

struct HorizontalLabelValue: View {
    var label: String
    var value: String
    var body: some View {
        Text(label)
            .bold()
            .font(.system(size: 18))
            .padding(.bottom, 2)
        
        Text(value)
            .font(.system(size: 18))
            .padding(.bottom, 20)
    }
}
