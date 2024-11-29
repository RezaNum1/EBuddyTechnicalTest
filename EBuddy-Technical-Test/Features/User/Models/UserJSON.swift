//
//  UserJSON.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 27/11/24.
//

import SwiftUI

struct UserJSON {
    var uid: String?
    var name: String?
    var email: String?
    var phoneNumber: String?
    var gender: GenderEnum?
    var imageUrl: String?
    var image: UIImage?
    var lastActive: String?
    var rating: Double?
    var price: Double?
}

enum GenderEnum: Int {
    case male = 1
    case female = 0

    var text: String {
        switch self {
        case .male: "Male"
        case .female: "Female"
        }
    }
}
