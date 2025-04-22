//
//  ProfileViewModel.swift
//  Clipkart
//
//  Created by pratik.nalawade on 31/10/24.
//

import Foundation

@Observable class ProfileViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    var isAccountDeleted: Bool = false
    
    // Other properties and methods...
}
