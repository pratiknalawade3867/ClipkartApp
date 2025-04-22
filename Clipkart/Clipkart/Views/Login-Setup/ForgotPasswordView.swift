import SwiftUI
import CoreData

struct ForgotPasswordView: View {
    @Environment(\.managedObjectContext) private var context
    @State var email: String = ""
    @State private var newPassword: String = ""
    @State private var message: String?
    @State private var isSubmitting: Bool = false
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Email TextField with styling
                CustomTextField(placeholder: "User Email", text: $email)
                
                // New Password TextField with styling
                CustomTextField(placeholder: "New Password", text: $newPassword, isSecure: true)
                
                // Reset Password Button with modern style
                ResetPasswordButton(isSubmitting: $isSubmitting, action: resetPassword, isButtonDisabled: email.isEmpty || newPassword.isEmpty)
                
                // Success/Error Message
                if let message = message {
                    Text(message)
                        .fontWeight(.bold)
                        .foregroundColor(message == "Password reset successfully!" ? .green : .red)
                        .padding(.top, 10)
                        .transition(.opacity)
                        .animation(.easeInOut, value: message)  // Smooth transition for message
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
        }
    }
    
    private func resetPassword() {
        isSubmitting = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            
            do {
                let users = try context.fetch(fetchRequest)
                if let user = users.first {
                    user.password = newPassword
                    try context.save()
                    message = "Password reset successfully!"
                } else {
                    message = "User not found."
                }
            } catch {
                message = "Failed to reset password."
            }
            
            isSubmitting = false
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                TextField(placeholder, text: $text)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}

struct ResetPasswordButton: View {
    @Binding var isSubmitting: Bool
    var action: () -> Void
    var isButtonDisabled: Bool
    
    var body: some View {
        Button(action: action) {
            Text(isSubmitting ? "Submitting..." : "Reset Password")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isButtonDisabled ? Color.gray : Color.blue) // Blue when enabled, gray when disabled
                .cornerRadius(10)
                .shadow(radius: 5)
                .scaleEffect(isSubmitting ? 1.1 : 1.0)
                .animation(.spring(), value: isSubmitting)
        }
        .disabled(isButtonDisabled || isSubmitting) // Disable if fields are empty or if submitting
    }
}
