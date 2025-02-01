//
//  BeforeAfterSection.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//

import SwiftUI

struct BeforeAfterSection: View {
    @Binding var beforeImage: UIImage?
    @Binding var afterImage: UIImage?
    @Binding var isBeforeImagePickerPresented: Bool
    @Binding var isAfterImagePickerPresented: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Before & After")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            HStack(spacing: 20) {
                if let beforeImage = beforeImage {
                    Image(uiImage: beforeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 200)
                        .cornerRadius(10)
                        .onTapGesture {
                            isBeforeImagePickerPresented.toggle()
                        }
                } else {
                    Button(action: {
                        isBeforeImagePickerPresented.toggle()
                    }) {
                        Text("Upload Before Image")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.appOrange)
                            .cornerRadius(10)
                    }
                }

                if let afterImage = afterImage {
                    Image(uiImage: afterImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 200)
                        .cornerRadius(10)
                        .onTapGesture {
                            isAfterImagePickerPresented.toggle()
                        }
                } else {
                    Button(action: {
                        isAfterImagePickerPresented.toggle()
                    }) {
                        Text("Upload After Image")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.appOrange)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
