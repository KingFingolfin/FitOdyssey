//
//  SignupView.swift
//  Wazaaaaaaaap
//
//  Created by Sandro Tsitskishvili on 21.12.24.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @State private var isNavigatingToLogin = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Sign up")
                    .foregroundStyle(.white)
                    .font(Font.system(size: 24))
                    .padding(.top, 20)
                
                VStack(spacing: 16) {
                    CustomTextField(title: "Full Name", placeholder: "Your full name", text: $viewModel.fullName)
                    CustomTextField(title: "Username", placeholder: "Your username", text: $viewModel.userName)
                    CustomTextField(title: "Email", placeholder: "Your email address", text: $viewModel.email, keyboardType: .emailAddress)
                    SecureTextField(title: "Enter Password", placeholder: "*********", text: $viewModel.password)
                    SecureTextField(title: "Confirm Password", placeholder: "*********", text: $viewModel.confirmPassword)
                }.padding(.top, 25)
                
                Spacer()
                
                if let errorMessage = viewModel.statusMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(viewModel.isSuccess ? .green : .red)
                        .padding(.bottom, 10)
                }
                
                Button(action: {
                    Task {
                        await viewModel.SignUp()
                        if viewModel.isSuccess {
                            viewModel.shouldNavigateToLogin = true
                        }
                    }
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity, maxHeight: 64)
                        .font(Font.custom("Inter", size: 20).weight(.semibold))
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(12)
                }
                .padding(.bottom, 20)
                
                NavigationLink(
                    destination: LoginView(),
                    isActive: $viewModel.shouldNavigateToLogin,
                    label: { EmptyView() }
                )
            }
            .padding(.horizontal, 24)
            .background(.appBackground)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}


