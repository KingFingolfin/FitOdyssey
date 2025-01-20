//
//  testView.swift
//  FitOdyssey
//
//  Created by Giorgi on 19.01.25.
//
//import SwiftUI
//
//struct StepCountView: View {
//    @StateObject private var viewModel = StepCountViewModel()
//
//    var body: some View {
//        VStack {
//            Text("Step Count Today")
//                .font(.headline)
//            Text("\(viewModel.stepCount)")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//        }
//        .padding()
//        .onAppear {
//            viewModel.fetchSteps()
//        }
//    }
//}
