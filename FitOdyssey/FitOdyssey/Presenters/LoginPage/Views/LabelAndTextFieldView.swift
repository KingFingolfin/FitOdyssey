//
//  LoginView.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//

import SwiftUI

struct LabelAndTextFieldView: View {
    @State private var isSecure: Bool = true
    @Binding var text: String
    var label: LocalizedStringKey
    var placeholder: LocalizedStringKey
    var isPassword: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleLabel
                .padding(.leading, 4)
            
            HStack {
                if isPassword {
                    customLockImage
                } else {
                    customMailImage
                }
                
                if isPassword && isSecure {
                    secureTextField
                } else {
                    regularTextField
                }
                
                if isPassword {
                    visibilityButton
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .padding(.bottom, 17)
            .padding(.top, 17)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 0)
            )
            .background(Color.appTextFieldBackGround)
        }
        .padding(.vertical, 17)
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
    
    private var titleLabel: some View {
        Text(label)
            .foregroundColor(.white)
    }
    
    private var customLockImage: some View {
        Image(systemName: "lock").foregroundStyle(.gray)
    }
    
    private var customMailImage: some View {
        Image(systemName: "envelope").foregroundStyle(.gray)
    }
    private var secureTextField: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
            }

            SecureField("", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .autocapitalization(.none)
                .foregroundColor(.white)
        }
    }

    private var regularTextField: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
            }

            TextField("", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .autocapitalization(.none)
                .foregroundColor(.white)
        }
    }

    
    private var visibilityButton: some View {
        Button(action: {
            isSecure.toggle()
        }) {
            Image(systemName: isSecure ? "eye.slash" : "eye")
                .foregroundColor(.gray)
        }
    }
}


