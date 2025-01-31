//
//  CustomTextField.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//
import SwiftUI

struct CustomTextField: View {
    let title: LocalizedStringKey
    let placeholder: LocalizedStringKey
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
            
            ZStack(alignment: .leading) {
                TextField("", text: $text)
                    .padding(10)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.appTextFieldBackGround)
                    )
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
                    .font(.custom("Inter", size: 15))
                    .focused($isFocused)
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                        .font(.custom("Inter", size: 15))
                        .allowsTightening(true)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }
        }
    }
}
