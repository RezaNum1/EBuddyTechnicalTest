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

    @State var phoneNumber: String = ""
    @State var selectedGender: Int = 99
    @State var name: String = ""
    @State var rating: String = "0,0"
    @State var price: String = "0,0"

    @State var selectedImage: UIImage?
    @State var isPickerShowing = false
    @State var validRating: Bool = true
    @State var validPrice: Bool = true

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
                    if !validRating {
                        Text("* Invalida rating value, Range input: 0.0 - 5.0")
                            .foregroundColor(Color.red)
                            .bold()
                            .padding(.bottom, 16)
                    }

                    if !validPrice {
                        Text("* Invalida price value")
                            .foregroundColor(Color.red)
                            .bold()
                            .padding(.bottom, 16)
                    }

                    HorizontalLabelValue(label: "ID", value: "\(user.uid ?? "")")

                    HorizontalLabelValue(label: "Email", value: "\(user.email ?? "")")

                    TextFiledLabel(label: "Name", value: $name)

                    TextFiledLabel(label: "Phone Number", value: $phoneNumber, keyboardType: .number)

                    GenderPickerView(label: "Select Gender", value: $selectedGender)
                        .padding(.bottom, 20)

                    TextFiledLabel(label: "Rating", value: $rating, keyboardType: .decimal)

                    TextFiledLabel(label: "Price", value: $price, keyboardType: .decimal)
                }
                .padding(.bottom, 30)

                GeneralButton(action: {
                    hideKeyboard()
                    self.validateRatingAndPrice()

                    if self.validPrice && self.validRating {
                        self.userVM.updateData(user: UserJSON(uid: user.uid, name: name, email: user.email, phoneNumber: phoneNumber, gender: GenderEnum(rawValue: selectedGender), lastActive: user.lastActive, rating: convertRating(), price: convertPrice()), selectedImage: selectedImage, loaderState: $mainVM.isLoading)
                    }
                }, label: "Save", isDisabled: !isFormFilled)
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            self.name = user.name ?? ""
            self.phoneNumber = user.phoneNumber ?? ""
            self.selectedGender = user.gender?.rawValue ?? 0
            self.rating = String(user.rating ?? 0.0).replacingOccurrences(of: ".", with: ",")
            self.price = String(user.price ?? 0.0).replacingOccurrences(of: ".", with: ",")

            if self.user.imageUrl != "" {
                self.userVM.retrieveImage(user: user, selectedImage: $selectedImage, loaderState: $mainVM.isLoading)
            }
        }
        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isPickerShowing)
        }
        .snackbar(show: $userVM.showSuccessBanner, bgColor: .green, txtColor: .white, icon: "checkmark", iconColor: .white, message: "Successfully Updated!")
        .snackbar(show: $userVM.showErrorBanner, bgColor: .red, txtColor: .white, icon: "xmark", iconColor: .white, message: "Something Wrong!")
    }

    var isFormFilled: Bool {
        return phoneNumber != "" && selectedGender != 99
    }

    func validateRatingAndPrice() {
        if let ratingValue = convertRating(), ratingValue >= 0.0, ratingValue <= 5.0 {
            validRating = true
        } else {
            validRating = false
        }

        if let _ = convertPrice() {
            validPrice = true
        } else {
            validPrice = false
        }
    }

    func convertRating() -> Double? {
        let formattedRating = rating.replacingOccurrences(of: ",", with: ".")
        return Double(formattedRating)
    }

    func convertPrice() -> Double? {
        let formattedPrice = price.replacingOccurrences(of: ",", with: ".")
        return Double(formattedPrice)
    }
}
