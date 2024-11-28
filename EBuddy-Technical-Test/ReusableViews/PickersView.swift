//
//  PickersView.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI

struct GenderPickerView: View {
    var label: String
    @Binding var value: Int

    var body: some View {
        HStack {
            Text(label)
                .bold()
                .font(.system(size: 18))

            Picker("", selection: $value) {
                Text("Male").tag(1).font(.title)
                Text("Female").tag(0).font(.title)
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
}
