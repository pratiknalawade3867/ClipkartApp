//
//  Login-ViewModel.swift
//  Clipkart
//
//  Created by pratik.nalawade on 31/10/24.
//

import Foundation
import CoreData

@Observable class LoginViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    var isNavigating: Bool = false
    var loginFailed: Bool = false
    var isLoggedIn: Bool = false
    var alertMessage: String = ""
    var showingResetPassword = false
    
    func login(in context: NSManagedObjectContext) {
        guard !email.isEmpty, !password.isEmpty else {  // Fix empty check
            loginFailed = true
            alertMessage = ViewStrings.alertFillDetails.getText()
            return
        }
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let users = try context.fetch(fetchRequest)  // Use context passed to function
            
            if let user = users.first {
                email = user.email ?? ""
                isLoggedIn = true
                var arrUser: UserTags = UserTags(email: user.email ?? "", fullName: user.fullname  ?? "", password: user.password  ?? "", confirmPassword: user.password  ?? "")
                SessionManager.shared.currentUser = arrUser
                print("Login successful for user: \(user.email ?? "Unknown")")

            } else {
                loginFailed = true
                alertMessage = ViewStrings.unknownuserTxt.getText()
                print("Login failed for \(email)")
            }
        } catch {
            loginFailed = true
            print("Failed to fetch users: \(error.localizedDescription)")
        }
    }
}
