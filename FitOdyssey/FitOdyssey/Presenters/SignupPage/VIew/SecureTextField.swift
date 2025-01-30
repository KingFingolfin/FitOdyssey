//
//  SecureTextField.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//
import SwiftUI

struct SecureTextField: View {
    let title: LocalizedStringKey
    let placeholder: LocalizedStringKey
    @Binding var text: String
    @State private var isSecure: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
            
            HStack {
                Image(.customLock)
                    .foregroundColor(.gray)
                
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.gray) 
                            .padding(.leading, 4)
                    }

                    Group {
                        if isSecure {
                            SecureField("", text: $text)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                        } else {
                            TextField("", text: $text)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                        }
                    }
                    .padding(.leading, 8)
                }

                Button(action: { isSecure.toggle() }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding(10)
            .frame(height: 52)
            .background(Color.appTextFieldBackGround)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 0)
            )
        }
    }
}
