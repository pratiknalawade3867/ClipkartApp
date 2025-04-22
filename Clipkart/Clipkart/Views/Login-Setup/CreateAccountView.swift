//
//  CreateAccountView.swift
//  Clipkart
//
//  Created by pratik.nalawade on 25/10/24.
//

import SwiftUI
import Combine
import CoreData

struct CreateAccountView: View {
    @StateObject var viewModel = CreateAccountViewModel()
    @Environment(\.dismiss) var dismiss  // For dismissing the view
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack(spacing: 16) {
            Text(ViewStrings.createAccountWelcomeMsg.getText())
                .font(.headline).fontWeight(.medium)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            InputView(
                placeholder: "\(ViewStrings.emailPlaceholderMand.getText())",
                text: $viewModel.email
            )
            if let emailError = viewModel.emailError {
                Text(emailError)
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            
            InputView(
                placeholder: "\(ViewStrings.fullNameTxt.getText())",
                text: $viewModel.fullName
            )
            if let fullNameError = viewModel.fullNameError {
                Text(fullNameError)
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            
            // MARK:  Password Input with toggle visibility
            InputView(
                placeholder: ViewStrings.passwordTxt.getText(),
                isSecureField: !viewModel.isPasswordVisible,
                text: $viewModel.password
            )
            .overlay(
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.isPasswordVisible.toggle()
                    }) {
                        Image(systemName: viewModel.isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                , alignment: .trailing
            )
            // MARK:  Confirm Password Input with toggle visibility
            ZStack(alignment: .trailing) {
                InputView(
                    placeholder: "Confirm your password",
                    isSecureField: !viewModel.isConfirmPasswordVisible,
                    text: $viewModel.confirmPassword
                )
                
                Button(action: {
                    viewModel.isConfirmPasswordVisible.toggle()
                }) {}
                
                Spacer()
                
                if !viewModel.password.isEmpty && !viewModel.confirmPassword.isEmpty {
                    Image(systemName: "\(isValidPassword ? "checkmark" : "xmark").circle.fill")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(isValidPassword ? Color(.systemGreen) : Color(.systemRed))
                }
            }
            
            Spacer()
            
            Button {
                viewModel.validateFields()
                register()
            } label: {
                Text("\(ViewStrings.createAccountTxt.getText())")
                    .fontWeight(.bold)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(12)
                    .shadow(radius: 10)
            }
            .buttonStyle(.bordered)
            
        }
        .navigationTitle("\(ViewStrings.setUpYourAccountTxt.getText())")
        .toolbarRole(.editor)
        .padding()
        .alert(isPresented: $viewModel.registrationStatus) {
            Alert(title: Text(ViewStrings.alertTxt.getText()), message: Text(viewModel.alertMessage), dismissButton: .default(Text(ViewStrings.okTxt.getText())) {
                dismiss()
            })
        }
    }
    
    // MARK: saving user in coredata

   func register() {
      // 1. Check if the email already exists
      let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "email == %@", viewModel.email)
       
      do {
           let existingUsers = try viewContext.fetch(fetchRequest)
          
           if !existingUsers.isEmpty {
               // Email already exists
              viewModel.emailError = "This email is already registered."
              return
           }
          
              // 2. Validate input fields
              guard !viewModel.email.isEmpty,
                    !viewModel.password.isEmpty,
                    !viewModel.fullName.isEmpty,
                    isValidPassword else {
                  viewModel.alertMessage = "Please fill user!"
                  return
               }
          
          // 3. Create new user
           let newUser = User(context: viewContext)
           newUser.email = viewModel.email
           newUser.password = viewModel.password
           newUser.fullname = viewModel.fullName
          
           try viewContext.save()
          
           viewModel.alertMessage = "User saved!"
           viewModel.registrationStatus = true
           print("User saved: \(newUser.email ?? "") \(newUser.password ?? "") \(newUser.fullname ?? "")")
          
       } catch {
           print("Failed to fetch or save user: \(error.localizedDescription)")
           viewModel.alertMessage = "Something went wrong. Please try again."
           viewModel.registrationStatus = false
        }
    }
    
    var isValidPassword: Bool {
        viewModel.confirmPassword == viewModel.password
    }
}

#Preview {
    CreateAccountView()
}

struct InputView: View {
    let placeholder: String
    var isSecureField: Bool = false
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 12) {
            if isSecureField {
                SecureField(placeholder, text: $text)
            }else {
                TextField(placeholder, text: $text)
            }
            Divider()
        }
    }
}
