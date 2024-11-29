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
    @Published var users: [UserJSON] = []
    @Published var showSuccessBanner: Bool = false
    @Published var showErrorBanner: Bool = false

    let firestoreManager = FirestoreManager(collectionName: "USERS")

    func fetchUsers() {
        firestoreManager.fetchDocuments { documents, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }

            for document in documents {
                let data = document.data()

                let id = document.documentID
                let name = data["name"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let gender = data["gender"] as? Int ?? 0
                let phoneNumber = data["phoneNumber"] as? String ?? ""
                let imageUrl = data["imageUrl"] as? String ?? ""
                let price = data["price"] as? Double ?? 0.0
                let rating = data["rating"] as? Double ?? 0.0
                let lastActive = data["lastActive"] as? String ?? ""

                if imageUrl != "" {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(imageUrl)

                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if let image = UIImage(data: data!), error == nil {
                            self.users.append(
                                UserJSON(
                                    uid: id,
                                    name: name,
                                    email: email,
                                    phoneNumber: phoneNumber,
                                    gender: GenderEnum(rawValue: gender),
                                    imageUrl: imageUrl,
                                    image: image,
                                    lastActive: lastActive,
                                    rating: rating,
                                    price: price
                                )
                            )
                        } else {
                            print(error)
                        }
                    }
                } else {
                    self.users.append(
                        UserJSON(
                            uid: id,
                            name: name,
                            email: email,
                            phoneNumber: phoneNumber,
                            gender: GenderEnum(rawValue: gender),
                            imageUrl: imageUrl,
                            lastActive: lastActive,
                            rating: rating,
                            price: price
                        )
                    )
                }
            }
        }
    }

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

                // Update Document Value & Image
                if insertError == nil {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)

                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if let image = UIImage(data: data!), error == nil {
                            self.updateDocumentAndImage(user: user, path: path, image: image)
                        } else {
                            self.showErrorBanner.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            loaderState.wrappedValue = false
                        }
                    }
                } else {
                    self.showErrorBanner.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        loaderState.wrappedValue = false
                    }
                }


            }
        } else { // Update Data Without Upload Image
            self.updateDocument(user: user)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                loaderState.wrappedValue = false
            }
        }
    }

    func updateDocument(user: UserJSON, path: String = "") {
        firestoreManager.updateDocument(
            idRef: user.uid ?? "",
            data: ["email": user.email ?? "", "phoneNumber": user.phoneNumber ?? "", "gender": user.gender?.rawValue ?? 0, "imageUrl": path, "name": user.name ?? "", "price": user.price ?? 0.0, "rating": user.rating ?? 0.0]) { [weak self] updateError in
                if updateError == nil {
                    self?.showSuccessBanner.toggle()

                    if let idx = self?.users.firstIndex(where: { $0.uid == user.uid }) {
                        self?.users[idx] = user
                    }

                } else {
                    self?.showErrorBanner.toggle()
                }
            }
    }

    func updateDocumentAndImage(user: UserJSON, path: String = "", image: UIImage) {
        firestoreManager.updateDocument(
            idRef: user.uid ?? "",
            data: ["email": user.email ?? "", "phoneNumber": user.phoneNumber ?? "", "gender": user.gender?.rawValue ?? 0, "imageUrl": path, "name": user.name ?? "", "price": user.price ?? 0.0, "rating": user.rating ?? 0.0]) { [weak self] updateError in
                if updateError == nil {
                    let newData = UserJSON(
                        uid: user.uid,
                        name: user.name,
                        email: user.email,
                        phoneNumber: user.phoneNumber,
                        gender: GenderEnum(rawValue: user.gender?.rawValue ?? 0),
                        imageUrl: path, image: image,
                        lastActive: user.lastActive,
                        rating: user.rating,
                        price: user.price
                    )

                    if let idx = self?.users.firstIndex(where: { $0.uid == user.uid }) {
                        DispatchQueue.main.async {
                            self?.users[idx] = newData
                        }
                    }

                    self?.showSuccessBanner.toggle()

                } else {
                    self?.showErrorBanner.toggle()
                }
            }
    }

    func insertImage(path: String, data: Data?, completion: @escaping ((any Error)?) -> Void) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(path)

        let _ = fileRef.putData(data!, metadata: nil) { metadata, error in
            if error != nil {
                completion(nil)
            } else {
                completion(error)
            }
        }
    }

    func retrieveImage(user: UserJSON, selectedImage: Binding<UIImage?>, loaderState: Binding<Bool>? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            loaderState?.wrappedValue = true
        })
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(user.imageUrl ?? "")

        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let image = UIImage(data: data!), error == nil {
                selectedImage.wrappedValue = image
            }

            loaderState?.wrappedValue = false
        }
    }
}
