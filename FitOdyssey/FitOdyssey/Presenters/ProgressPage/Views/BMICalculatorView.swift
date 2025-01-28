//
//  BMICalculatorView.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//

import SwiftUI

struct BMICalculatorView: View {
    @Binding var weight: Double
    @Binding var height: Double
    @Binding var weightUnit: WeightUnit
    @Binding var heightUnit: HeightUnit
    
    @State private var bmiScore: Double = 0
    @State private var bmiCategory: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Text("BMI Calculator")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                
                VStack {
                    Text("Weight")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    HStack {
                        TextField("Enter", value: $weight, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        Picker("", selection: $weightUnit) {
                            ForEach(WeightUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                VStack {
                    Text("Height")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    HStack {
                        TextField("Enter", value: $height, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        Picker("", selection: $heightUnit) {
                            ForEach(HeightUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
            }
            .onChange(of: weight) { _ in calculateBMI() }
            .onChange(of: height) { _ in calculateBMI() }
            .onChange(of: weightUnit) { _ in calculateBMI() }
            .onChange(of: heightUnit) { _ in calculateBMI() }
            
            VStack(spacing: 5) {
                Text("BMI: \(bmiScore, specifier: "%.1f")")
                    .foregroundColor(.white)
                
                Text(bmiCategory)
                    .foregroundColor(bmiCategoryColor)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.2))
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
    
    private func calculateBMI() {
        var convertedWeight = weight
        var convertedHeight = height
        
        if weightUnit == .lbs {
            convertedWeight = weight * 0.453592
        }
        
        switch heightUnit {
        case .cm:
            convertedHeight = height / 100
        case .inches:
            convertedHeight = height * 0.0254
        case .meters:
            break
        }
        
        bmiScore = BMICalculator.calculateBMI(weight: convertedWeight, height: convertedHeight)
        bmiCategory = BMICalculator.bmiCategory(score: bmiScore)
    }
    
    private var bmiCategoryColor: Color {
        switch bmiCategory {
        case "Underweight": return .blue
        case "Normal": return .green
        case "Overweight": return .orange
        case "Obese": return .red
        default: return .gray
        }
    }
}

struct BMICalculator {
    static func calculateBMI(weight: Double, height: Double) -> Double {
        guard height > 0 else { return 0 }
        return weight / (height * height)
    }
    
    static func bmiCategory(score: Double) -> String {
        switch score {
        case ..<18.5: return "Underweight"
        case 18.5..<25: return "Normal"
        case 25..<30: return "Overweight"
        case 30...: return "Obese"
        default: return "N/A"
        }
    }
}
