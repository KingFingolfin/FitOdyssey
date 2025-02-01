//
//  CustomSegmentedPicker.swift
//  FitOdyssey
//
//  Created by Giorgi on 29.01.25.
//

import SwiftUI

struct CustomSegmentedPicker: View {
    @Binding var selectedOption: String
    let options: [String]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(options, id: \.self) { option in
                Text(option)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(selectedOption == option ? .white : .gray)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(selectedOption == option ? Color.orange : Color.clear)
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedOption = option
                    }
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
