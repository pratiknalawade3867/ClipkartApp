//
//  UserTags.swift
//  Clipkart
//
//  Created by pratik.nalawade on 25/10/24.
//

import Foundation

struct UserTags : Codable {
    let email: String
    let fullName: String
    let password: String
    let confirmPassword: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
