//
//  LoginView.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//

import FirebaseAuth
import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LogInViewModel()
    @State private var navigateToRegisterPage = false
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                ScrollView{
                    VStack {
                        Image(.mainLogo)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 50)
                            .padding(.bottom, 20)
                        
                        mainLabel
                        
                        LabelAndTextFieldView(
                            text: $viewModel.email,
                            label: "Email",
                            placeholder: "Your email address"
                        )
                        .padding(.top)
                        
                        LabelAndTextFieldView(
                            text: $viewModel.password,
                            label: "Password",
                            placeholder: "Your password",
                            isPassword: true
                        )
                        
                        loginButton
                            .padding()
                        
                        HStack {
                            newUserQuestionLabel
                            Spacer()
                            signUpButton
                        }
                        .padding(.leading, 32)
                        .padding(.trailing, 18)
                        
                        
                        
                        continueWithGoogleButton
                            .padding(.horizontal)
                            .padding(.top, 100)
                        
                        
                    }
                    .padding()
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Login Error"),
                    message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .fullScreenCover(isPresented: $viewModel.isLogedIn) {
                TabBarWrapperView().ignoresSafeArea()
            }
            .navigationDestination(isPresented: $navigateToRegisterPage) {
                SignupView()
            }
        }
        .onAppear {
            if Auth.auth().currentUser != nil {
                DispatchQueue.main.async {
                            isLoggedIn = true
                        }
            }
        }
        .navigationBarBackButtonHidden(true)
        .tint(.appOrange)
    }

    
    private var backgroundColor: some View {
        Color.appBackground
    }
    
    private var mainLabel: some View {
        Text("Login to your Accaunt")
            .foregroundStyle(.white)
            .font(Font.system(size: 24))
            .bold()
    }
    
    private var newUserQuestionLabel: some View {
        Text("Don't have an account?")
            .foregroundStyle(.white)
    }
    
    private var signUpButton: some View {
        Button("Sign up") {
            navigateToRegisterPage = true
        }
        .foregroundColor(.orange)
        
    }

    
    private var continueWithGoogleButton: some View {
        VStack{
            Text("Alternatively Login with:")
                .foregroundStyle(.white)
                .padding(.bottom, 5)
            
            Button(action: {
                viewModel.signInWithGmail(presentation: getRootViewController()) { error in
                    if let error = error {
                        print("Sign-In Failed: \(error.localizedDescription)")
                    } else {
                        print("Sign-In Successful!")
                    }
                }
            }) {
                HStack {
                    Image(.google)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 23, height: 23)
                    
                    Text("Login With Google")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .frame(width: 327, height: 50)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orange, lineWidth: 2)
                )
                .cornerRadius(10)
            }
        }
    }

    
    private var loginButton: some View {
        Button(action: {
            viewModel.logIn()
        }) {
            Text("Log In")
                .frame(width: 327)
                .padding(.top, 20)
                .padding(.bottom, 20)
                .foregroundColor(.white)
                .background(.orange)
                .cornerRadius(12)
        }
    }
}

