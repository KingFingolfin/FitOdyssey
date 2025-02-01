//
//  SearchBar.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text("Search Exercises")
                    .foregroundColor(.gray)
                    .padding(.leading, 55)
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                
                TextField("", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.white)
            }
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}
