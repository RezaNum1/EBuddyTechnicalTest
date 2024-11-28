//
//  MainViewModel.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 29/11/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var isLoading: Bool = false

    func showLoader() {
        isLoading = true
    }

    func dismissLoader() {
        isLoading = false
    }
}
