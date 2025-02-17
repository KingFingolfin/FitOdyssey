//
//  SignupView.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @State private var isSignupSuccess = false

    var body: some View {
        ZStack {
            Color.appBackground.edgesIgnoringSafeArea(.all) 
            
            ScrollView {
                VStack(spacing: 16) {
                    VStack {
                        Text("Create an Account")
                            .foregroundStyle(.white)
                            .font(.system(size: 24, weight: .bold))
                            .padding(.top, 20)
                        Text("Help us finish setting up your account")
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                    }
                    
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Name",
                            placeholder: "Your name",
                            text: $viewModel.name
                        )
                        CustomTextField(
                            title: "Age",
                            placeholder: "Your age",
                            text: $viewModel.age,
                            keyboardType: .numberPad
                        )
                        CustomTextField(
                            title: "Weight (kg)",
                            placeholder: "Your weight in kg",
                            text: $viewModel.weight,
                            keyboardType: .decimalPad
                        )
                        CustomTextField(
                            title: "Height (cm)",
                            placeholder: "Your height in cm",
                            text: $viewModel.height,
                            keyboardType: .decimalPad
                        )
                        CustomTextField(
                            title: "Gender",
                            placeholder: "Male or Female",
                            text: $viewModel.gender
                        )
                        CustomTextField(
                            title: "Email",
                            placeholder: "Your email address",
                            text: $viewModel.email,
                            keyboardType: .emailAddress
                        )
                        SecureTextField(
                            title: "Enter Password",
                            placeholder: "*********",
                            text: $viewModel.password
                        )
                        SecureTextField(
                            title: "Confirm Password",
                            placeholder: "*********",
                            text: $viewModel.confirmPassword
                        )
                    }
                    .padding(.top, 25)

                    if let errorMessage = viewModel.statusMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(viewModel.isSuccess ? .green : .red)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                    }

                    Button(action: {
                        Task {
                            await viewModel.SignUp()
                            if viewModel.isSuccess {
                                isSignupSuccess = true
                            }
                        }
                    }) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity, minHeight: 64)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .background(Color.orange)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
            }
        }
        .navigationDestination(isPresented: $isSignupSuccess) {
            TabBarWrapperView().ignoresSafeArea()
        }
    }
}

