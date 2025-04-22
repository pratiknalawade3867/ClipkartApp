//
//  CreateAccountViewModel.swift
//  Clipkart
//
//  Created by pratik.nalawade on 25/10/24.
//

import Foundation
import CoreData
import UIKit

@Observable class CreateAccountViewModel: ObservableObject {
    var userTags: [UserTags] = []
    var email: String =   ""
    var fullName: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var registrationSuccess: Bool = false
    var registrationFail: Bool = false
    var alertMessage: String = ""
    var emailError: String?
    var fullNameError: String?
    var isPasswordVisible = false // Toggle for password visibility
    var isConfirmPasswordVisible = false // Toggle for confirm password visibility
    
    func validateFields() -> Bool {
        let isValid = true
        
        emailError = email.isEmpty ? "Email is required" : nil
        fullNameError = fullName.isEmpty ? "Full Name is required" : nil
        
        return isValid
    }
}
