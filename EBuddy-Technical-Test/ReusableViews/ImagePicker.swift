//
//  ImagePicker.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import UIKit
import SwiftUI

// Step 1: Create a struct to wrap UIImagePickerController
struct ImagePicker: UIViewControllerRepresentable {
    // Binding to manage the selected image
    @Binding var selectedImage: UIImage?
    @Binding var isImagePickerPresented: Bool

    // Coordinator to handle image picker delegation
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Get the selected image
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            // Dismiss the image picker
            parent.isImagePickerPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // If the user cancels, dismiss the picker
            parent.isImagePickerPresented = false
        }
    }

    // Step 2: Create the makeCoordinator method
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    // Step 3: Define the view controller to be displayed
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary // Set source type as photo library
        return picker
    }

    // Step 4: Required method for UIViewControllerRepresentable
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
