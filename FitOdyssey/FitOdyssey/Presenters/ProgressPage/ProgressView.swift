//
//  ProgressView.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//

import SwiftUI

struct ProgressPageView: View {
    
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                Text("PROGRESS")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.appOrange)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .background(.appBackground)
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        
    }
}
