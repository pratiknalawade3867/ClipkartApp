//
//  LoginView.swift
//  Clipkart
//
//  Created by pratik.nalawade on 25/10/24.
//

import SwiftUI
import CoreData

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @State private var logoScale: CGFloat = 1.0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // logo
                    logo
                        .scaleEffect(logoScale)
                        .onAppear {
                            // Add an animation to the logo when the view appears
                            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                logoScale = 1.1
                            }
                        }
                    // title
                    titleView
                    
                    Spacer().frame(height: 12)
                    
                    // textfields
                    InputView(
                        placeholder: ViewStrings.emailPlaceholder.getText(),
                        text: $viewModel.email
                    )
                    
                    InputView(
                        placeholder: ViewStrings.passwordTxt.getText(),
                        isSecureField: true,
                        text: $viewModel.password
                    )
                    
                    // forgot button
                    HStack {
                        Spacer()
                        Button(ViewStrings.forgotPassTxt.getText()) {
                            viewModel.showingResetPassword = true
                        }
                        .foregroundStyle(.gray)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    }
                    
                    // login button
                    Button(action: {
                        viewModel.login(in: viewContext)
                    }) {
                        Text(ViewStrings.loginBtn.getText())
                            .fontWeight(.bold)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    NavigationLink(destination: MainView(), isActive: $viewModel.isLoggedIn) {
                        EmptyView()
                    }
                }
                
                Spacer()
                
                // bottom view
                bottomView
                
                //footer view
                NavigationLink(destination: CreateAccountView()) {
                    HStack {
                        Text(ViewStrings.donthaveaccTxt.getText())
                            .foregroundColor(.primary)
                        Text("Sign Up")
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .ignoresSafeArea()
        .padding(.horizontal)
        .background(Color(UIColor.systemBackground))  // Dynamic background based on dark/light mode
        .padding(.vertical, 8)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $viewModel.loginFailed) {
            Alert(title: Text(ViewStrings.alertTxt.getText()), message: Text(viewModel.alertMessage), dismissButton: .default(Text(ViewStrings.okTxt.getText())))
        }
        .sheet(isPresented: $viewModel.showingResetPassword) {
            ForgotPasswordView(email: viewModel.email)
        }
    }
}

private var logo: some View {
    Image("login_image")
        .resizable()
        .scaledToFit()
}

private var titleView: some View {
    Text(ViewStrings.welcomeMessage.getText())
        .font(.title2)
        .fontWeight(.semibold)
        .foregroundColor(.primary)
}

private var line: some View {
    VStack { Divider().frame(height: 1) }
}

private var bottomView: some View {
    VStack(spacing: 16) {
        lineorView
        appleButton
        googleButton
    }
}

private var lineorView: some View {
    HStack(spacing: 16) {
        line
        Text(ViewStrings.orLbl.getText())
            .fontWeight(.semibold)
        line
    }
    .foregroundStyle(.gray)
}

private var appleButton: some View {
    Button {
        
    } label: {
        Label(ViewStrings.signupApple.getText(), systemImage: "apple.logo")
    }
    .buttonStyle(.bordered)
}

private var googleButton: some View {
    Button {} label: {
        HStack {
            Image("google")
                .resizable()
                .frame(width: 15, height: 15)
            Text(ViewStrings.signupGoogle.getText())
        }
    }
}

#Preview {
    LoginView()
}
