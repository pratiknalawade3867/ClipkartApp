//
//  Constants.swift
//  ClipkartPlus
//
//  Created by pratik.nalawade on 31/10/24.
//

import Foundation

extension String {

    func localized() -> String {
         let defaultLanguage = Locale.preferredLanguages.first?.components(separatedBy: "-").first
            return NSLocalizedString(self, comment: "")
        }
    }

enum ViewStrings: String {
    func getText() -> String {
        rawValue.localized()
    }
    
    // MARK: - Common
    case emailPlaceholder = "Email or Phone number!"
    case emailPlaceholderMand = "Email or Phone number *"
    case fullNameTxt = "Full Name *"
    case blank = ""
    case dash = "-"
    case space = " "
    case welcomeMessage = "Let's Connect With US!"
    case orLbl = "or"
    case signupApple = "Sign up with Apple"
    case signupGoogle = "Sign up with Google"
    case alertFillDetails = "Please fill some detail!"
    case alertTxt = "Alert"
    case okTxt = "OK"
    case unknownuserTxt = "Unknown user!"
    case loginBtn = "Login"
    case logoutBtn = "Log Out"
    case forgotPassTxt = "Forgot Password?"
    case passwordTxt = "Password"
    case donthaveaccTxt = "Don't have an account?"
    case createAccountTxt = "Create Account"
    case setUpYourAccountTxt = "Set up your account"
    
    case createAccountWelcomeMsg = "Please complete all information to create an account."
    case deleteAccountTxt = "Delete Account"
    case profileLbl = "Profile"
    case settingLbl = "Settings"
    
    case workinprogressLbl = "Work in progress..."
    
    case mywishlistLbl = "My Wishlist"
    
    case exploreLbl = "Explore"
    
    case sellonflipkartLbl = "Sell on Clipkart"
    
    case orderHistoryLbl = "Order History"
    
    case helpbotLbl = "Help Bot"
    
    case orderConfirmPermission = "Are you sure you want to place this order?"
    case orderPlacedTxt = "Order Placed!"
}
