//
//  LoginView.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//

//import FirebaseAuth
import SwiftUI

struct HomeView: View {
    
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                Text("HOME")
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
