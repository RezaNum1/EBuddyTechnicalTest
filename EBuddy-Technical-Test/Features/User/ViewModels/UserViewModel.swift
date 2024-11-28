//
//  UserViewModel.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 27/11/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var showSuccessBanner: Bool = false
    @Published var showErrorBanner: Bool = false

    func updateData(user: UserJSON, selectedImage: UIImage?, loaderState: Binding<Bool>) {
        loaderState.wrappedValue = true
        let storageRef = Storage.storage().reference()

        // Replace Photo
        if let prevImageUrl = user.imageUrl, prevImageUrl != "" {
            let deleteFileRef = storageRef.child(prevImageUrl)

            let _ = deleteFileRef.delete() {[weak self] error in
                if error == nil {
                    return
                } else {
                    self?.showErrorBanner.toggle()
                }
            }
        }


        // Update New Data & Upload New Image
        if selectedImage != nil {
            guard selectedImage != nil else {
                return
            }

            let imageData = selectedImage!.jpegData(compressionQuality: 0.8)

            guard imageData != nil else {
                return
            }

            let path = "images/\(UUID().uuidString).jpg"

            self.insertImage(path: path, data: imageData) { insertError in
                if insertError == nil {
                    self.updateDocument(user: user, path: path)
                } else {
                    self.showErrorBanner.toggle()
                }

                loaderState.wrappedValue = false
            }
        } else { // Update Data Without Upload Image
            self.updateDocument(user: user)
            loaderState.wrappedValue = false
        }
    }

    func updateDocument(user: UserJSON, path: String = "") {
        let firestoreManager = FirestoreManager(collectionName: "USERS")
        firestoreManager.updateDocument(
            idRef: user.uid ?? "",
            data: ["email": user.email ?? "", "phoneNumber": user.phoneNumber ?? "", "gender": user.gender?.rawValue ?? 0, "imageUrl": path]) { [weak self] updateError in
                if updateError == nil {
                    self?.showSuccessBanner.toggle()
                } else {
                    self?.showErrorBanner.toggle()
                }
            }
    }

    func insertImage(path: String, data: Data?, completion: @escaping ((any Error)?) -> Void) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(path)

        let _ = fileRef.putData(data!, metadata: nil) { _, error in
            if error != nil {
                completion(nil)
            } else {
                completion(error)
            }
        }
    }

    func retrieveImage(user: UserJSON, selectedImage: Binding<UIImage?>, loaderState: Binding<Bool>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            loaderState.wrappedValue = true
        })
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(user.imageUrl ?? "")

        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let image = UIImage(data: data!), error == nil {
                selectedImage.wrappedValue = image
            }

            loaderState.wrappedValue = false
        }
    }
}
