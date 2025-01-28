//
//  ProfileField.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//

import SwiftUI

struct ProfileField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(LocalizedStringKey(title))
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("", text: $text, prompt: Text(LocalizedStringKey(placeholder)))
                .padding()
                .background(Color.appTextFieldBackGround)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal)
    }
}
