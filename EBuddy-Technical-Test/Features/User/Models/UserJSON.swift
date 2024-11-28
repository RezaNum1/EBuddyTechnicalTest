//
//  UserJSON.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 27/11/24.
//

struct UserJSON {
    var uid: String?
    var email: String?
    var phoneNumber: String?
    var gender: GenderEnum?
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
