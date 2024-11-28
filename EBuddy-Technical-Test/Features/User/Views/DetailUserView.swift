//
//  DetailUserView.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct DetailUserView: View {
    @EnvironmentObject var mainVM: MainViewModel
    var user: UserJSON

    @State var email: String = ""
    @State var phoneNumber: String = ""
    @State var selectedGender: Int = 99

    @State var selectedImage: UIImage?
    @State var isPickerShowing = false
    @State var showSuccessBanner: Bool = false
    @State var showErrorBanner: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: 350, height: 400)
                        .onTapGesture {
                            self.isPickerShowing = true
                        }
                        .cornerRadius(8)
                        .padding(.bottom, 16)
                } else {
                    PickImageView {
                        self.isPickerShowing = true
                    }
                    .padding(.bottom, 16)
                }

                VStack(alignment: .leading, spacing: 0){
                    HorizontalLabelValue(label: "ID", value: "\(user.uid ?? "")")

                    TextFiledLabel(label: "Email", value: $email)

                    TextFiledLabel(label: "Phone Number", value: $phoneNumber)

                    GenderPickerView(label: "Select Gender", value: $selectedGender)
                }
                .padding(.bottom, 30)

                GeneralButton(action: {
                    hideKeyboard()
                    updateData(user: UserJSON(uid: user.uid, email: email, phoneNumber: phoneNumber, gender: GenderEnum(rawValue: selectedGender)))
                }, label: "Save", isDisabled: !isFormFilled)
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            self.email = user.email ?? ""
            self.phoneNumber = user.phoneNumber ?? ""
            self.selectedGender = user.gender?.rawValue ?? 0
            if self.user.imageUrl != "" {
                self.retrieveImage()
            }
        }
        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isPickerShowing)
        }
        .snackbar(show: $showSuccessBanner, bgColor: .green, txtColor: .white, icon: "checkmark", iconColor: .white, message: "Successfully Updated!")
        .snackbar(show: $showErrorBanner, bgColor: .red, txtColor: .white, icon: "xmark", iconColor: .white, message: "Something Wrong!")
    }

    var isFormFilled: Bool {
        return email != "" && phoneNumber != "" && selectedGender != 99
    }

    func updateData(user: UserJSON) {
        let storageRef = Storage.storage().reference()

        // Replace Photo
        if let prevImageUrl = user.imageUrl, prevImageUrl != "" {
            let deleteFileRef = storageRef.child(prevImageUrl)

            let _ = deleteFileRef.delete() { error in
                if error == nil {
                    return
                } else {
                    self.showErrorBanner.toggle()
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
            }
        } else { // Update Data Without Upload Image
            self.updateDocument(user: user)
        }
    }

    func updateDocument(user: UserJSON, path: String = "") {
        let firestoreManager = FirestoreManager(collectionName: "USERS")
        firestoreManager.updateDocument(
            idRef: user.uid ?? "",
            data: ["email": user.email ?? "", "phoneNumber": user.phoneNumber ?? "", "gender": user.gender?.rawValue ?? 0, "imageUrl": path]) { updateError in
                if updateError == nil {
                    self.showSuccessBanner.toggle()
                } else {
                    self.showErrorBanner.toggle()
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

    func retrieveImage() {
        mainVM.showLoader()
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(user.imageUrl ?? "")

        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let image = UIImage(data: data!), error == nil {
                self.selectedImage = image
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                mainVM.dismissLoader()
            })
        }
    }
}
