//
//  TabButton.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//

import SwiftUI

struct TabButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Text(text)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(isSelected ? .white : .clear)
            }
        }
    }
}
