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
    @EnvironmentObject var userVM: UserViewModel
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
                    self.userVM.updateData(user: UserJSON(uid: user.uid, email: email, phoneNumber: phoneNumber, gender: GenderEnum(rawValue: selectedGender)), selectedImage: selectedImage, loaderState: $mainVM.isLoading)
                }, label: "Save", isDisabled: !isFormFilled)
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            self.email = user.email ?? ""
            self.phoneNumber = user.phoneNumber ?? ""
            self.selectedGender = user.gender?.rawValue ?? 0
            if self.user.imageUrl != "" {
                self.userVM.retrieveImage(user: user, selectedImage: $selectedImage, loaderState: $mainVM.isLoading)
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
}
