//
//  ProgressView.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//
import SwiftUI

struct ProgressPageView: View {
    @StateObject private var profileViewModel = ProfileViewModel()

    @State private var biceps: Double = 0
    @State private var shoulders: Double = 0
    @State private var waist: Double = 0
    @State private var chest: Double = 0
    @State private var weight: Double = 0
    @State private var height: Double = 0
    @State private var bmiScore: Double = 0
    @State private var bmiCategory: String = ""
    @State private var weightUnit: WeightUnit = .kg
    @State private var heightUnit: HeightUnit = .meters

    @State private var isBeforeImagePickerPresented = false
    @State private var isAfterImagePickerPresented = false

    var body: some View {
            ZStack {
                Color.appBackground.edgesIgnoringSafeArea(.all)
                
                ScrollView {
//                    WaterTrackerView()
//                        .preferredColorScheme(.dark)
//                    
//                        .frame(width: 300, height: 500)
                    
                    StepsTrackerView()
                    
                    VStack(spacing: 20) {
                        BeforeAfterSection(
                            beforeImage: $profileViewModel.beforeImage,
                            afterImage: $profileViewModel.afterImage,
                            isBeforeImagePickerPresented: $isBeforeImagePickerPresented,
                            isAfterImagePickerPresented: $isAfterImagePickerPresented
                        )
                        .padding()
                        .background(Color.appBackground.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 5)

                        HStack(spacing: 5) {
                            MeasurementColumn(label: "Biceps", value: $biceps, color: .blue, maxHeight: 250)
                            MeasurementColumn(label: "Shoulders", value: $shoulders, color: .green, maxHeight: 250)
                            MeasurementColumn(label: "Waist", value: $waist, color: .purple, maxHeight: 250)
                            MeasurementColumn(label: "Chest", value: $chest, color: .red, maxHeight: 250)
                            MeasurementColumn(label: "Weight", value: $weight, color: .yellow, maxHeight: 250)
                        }
                        
                        Button(action: saveMeasurements) {
                            Text("Save Measurements")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.appOrange)
                                .cornerRadius(10)
                        }
                        
                        MeasurementGraphView(measurements: $profileViewModel.profile.measurements)
                        
                        BMICalculatorView(
                            weight: $weight,
                            height: $height,
                            weightUnit: $weightUnit,
                            heightUnit: $heightUnit
                        )
                        
                        
                    }
                    .padding()
                    .navigationBarBackButtonHidden(true)
                    .sheet(isPresented: $isBeforeImagePickerPresented) {
                        ImagePicker(image: $profileViewModel.beforeImage)
                            .onDisappear {
                                profileViewModel.uploadBeforeImage()
                            }
                    }
                    .sheet(isPresented: $isAfterImagePickerPresented) {
                        ImagePicker(image: $profileViewModel.afterImage)
                            .onDisappear {
                                profileViewModel.uploadAfterImage()
                            }
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                loadLatestMeasurements()
                            }
            }
        }
        
        private func saveMeasurements() {
            profileViewModel.saveMeasurements(
                biceps: biceps,
                shoulders: shoulders,
                waist: waist,
                chest: chest,
                weight: weight
            )
        }
        
        private func loadLatestMeasurements() {
            if let latest = profileViewModel.loadLatestMeasurements() {
                biceps = latest.biceps
                shoulders = latest.shoulders
                waist = latest.waist
                chest = latest.chest
                weight = latest.weight
                
            }
        }
    }

