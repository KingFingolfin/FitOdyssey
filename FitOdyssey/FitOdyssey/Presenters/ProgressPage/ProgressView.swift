//
//  ProgressView.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//
import SwiftUI

enum WeightUnit: String, CaseIterable {
    case kg = "kg"
    case lbs = "lbs"
}

enum HeightUnit: String, CaseIterable {
    case meters = "m"
    case cm = "cm"
    case inches = "in"
}

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



struct MeasurementColumn: View {
   let label: String
   @Binding var value: Double
   let color: Color
   let maxHeight: CGFloat
   
   var body: some View {
       VStack(spacing: 6) {
           Text(label)
               .font(.caption2)
               .lineLimit(1)
               .minimumScaleFactor(0.5)
               .foregroundColor(.white)
               .padding(.horizontal, 4)
               .background(color.opacity(0.2))
               .cornerRadius(4)
           
           Spacer()
           
           TextField("", value: $value, formatter: NumberFormatter())
               .font(.footnote)
               .fontWeight(.semibold)
               .foregroundColor(color)
               .multilineTextAlignment(.center)
               .lineLimit(1)
               .minimumScaleFactor(0.5)
               .padding(4)
               .background(
                   RoundedRectangle(cornerRadius: 6)
                       .fill(Color.appBackground)
                       .shadow(color: color.opacity(0.2), radius: 2, x: 0, y: 1)
               )
           
           Spacer()
           
           Rectangle()
               .fill(
                   LinearGradient(
                       gradient: Gradient(colors: [color.opacity(0.6), color]),
                       startPoint: .bottom,
                       endPoint: .top
                   )
               )
               .frame(width: nil, height: min(value / 200 * maxHeight, maxHeight))
               .cornerRadius(6)
               .shadow(color: color.opacity(0.3), radius: 2, x: 0, y: 1)
       }
       .frame(maxWidth: .infinity)
       .padding(6)
       .background(
           RoundedRectangle(cornerRadius: 10)
               .fill(Color.black.opacity(0.1))
       )
       .animation(.spring(), value: value)
   }
}


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





import Charts

struct MeasurementGraphView: View {
    @Binding var measurements: [Measurements]
    @State private var selectedMeasurement: String = "Biceps"
    
    var filteredData: [(date: Date, value: Double)] {
        let groupedByDate = Dictionary(grouping: measurements, by: { Calendar.current.startOfDay(for: $0.date) })
        
        let latestMeasurements = groupedByDate.compactMap { (date, measurementsForDay) -> (Date, Double)? in
            guard let latestMeasurement = measurementsForDay.sorted(by: { $0.date > $1.date }).first else {
                return nil
            }
            return (date, measurementValue(for: latestMeasurement))
        }
        
        return latestMeasurements.sorted { (lhs: (date: Date, value: Double), rhs: (date: Date, value: Double)) -> Bool in
            lhs.date < rhs.date
        }
    }

    private func measurementValue(for measurement: Measurements) -> Double {
        switch selectedMeasurement {
        case "Biceps":
            return measurement.biceps
        case "Chest":
            return measurement.chest
        case "Waist":
            return measurement.waist
        case "Shoulders":
            return measurement.shoulders
        case "Weight":
            return measurement.weight
        default:
            return 0
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Measurement Graph")
                .font(.headline)
                .foregroundColor(.white)
            
            Picker("Measurement", selection: $selectedMeasurement) {
                ForEach(["Biceps", "Chest", "Waist", "Shoulders", "Weight"], id: \.self) { measurement in
                    Text(measurement).tag(measurement)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if filteredData.isEmpty {
                Text("No data available for \(selectedMeasurement).")
                    .foregroundColor(.gray)
                    .italic()
                    .padding()
            } else {
                Chart {
                    ForEach(filteredData, id: \.date) { entry in
                        LineMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Value", entry.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(LinearGradient(
                            colors: [.blue, .green],
                            startPoint: .bottom,
                            endPoint: .top
                        ))
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) {
                        AxisValueLabel(format: .dateTime.weekday(), centered: true)
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic)
                }
                .frame(height: 300)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.2))
                )
            }
        }
        .padding()
    }
}

//
//import SwiftUI
//
//struct WaterTrackerView: View {
//    @State private var currentWater: Double = 0
//    @State private var goal: Double = 3
//    @State private var waterHeight: CGFloat = 0
//    @State private var customGoal: String = "3"
//    
//    let maxWater: Double = 3
//    
//    // Timer to reset the water at midnight (simulate with a 1-second timer for demo)
//    @State private var resetTimer: Timer?
//    
//    var body: some View {
//        VStack {
//            // Custom Daily Goal Input
//            HStack {
//                Text("Set Daily Goal (L):")
//                    .font(.headline)
//                TextField("Goal", text: $customGoal)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .keyboardType(.decimalPad)
//                    .onSubmit {
//                        if let newGoal = Double(customGoal) {
//                            goal = newGoal
//                        }
//                    }
//                    .frame(width: 80)
//            }
//            .padding()
//            
//            // Glass Background with Realistic Look
//            ZStack {
//                RoundedRectangle(cornerRadius: 30)
//                    .fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
//                    .shadow(radius: 10)
//                    .frame(width: 200, height: 300)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 30)
//                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
//                    )
//                
//                // Water Fill
//                RoundedRectangle(cornerRadius: 30)
//                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.cyan]), startPoint: .top, endPoint: .bottom))
//                    .frame(width: 200, height: waterHeight)
//                    .cornerRadius(20)
//                    .animation(.easeInOut(duration: 0.5), value: waterHeight)
//                    .position(x: 150, y: 300 - (waterHeight / 2))
//            }
//            
//            // Display current water and goal
//            HStack {
//                Text("Goal: \(Int(goal))L")
//                    .font(.headline)
//                Spacer()
//                Text("Water: \(Int(currentWater))L")
//                    .font(.headline)
//            }
//            .padding()
//
//            // Controls: + and -
//            HStack {
//                Button(action: {
//                    if currentWater > 0 {
//                        currentWater -= 1
//                        waterHeight = CGFloat(currentWater / goal) * 300
//                    }
//                }) {
//                    Image(systemName: "minus.circle.fill")
//                        .font(.largeTitle)
//                        .foregroundColor(.white)
//                }
//                .padding()
//                
//                Button(action: {
//                    if currentWater < goal {
//                        currentWater += 1
//                        waterHeight = CGFloat(currentWater / goal) * 300
//                    }
//                }) {
//                    Image(systemName: "plus.circle.fill")
//                        .font(.largeTitle)
//                        .foregroundColor(.white)
//                }
//                .padding()
//            }
//        }
//        .onAppear {
//            setupDailyReset()
//        }
//        .onChange(of: currentWater) { newValue in
//            waterHeight = CGFloat(newValue / goal) * 300
//        }
//    }
//    
//    // Function to reset water daily
//    func setupDailyReset() {
//        let calendar = Calendar.current
//        let currentDate = Date()
//        let nextDay = calendar.nextDate(after: currentDate, matching: .init(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime)!
//        
//        // Schedule the reset for the next midnight
//        let timeInterval = nextDay.timeIntervalSince(currentDate)
//        
//        resetTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
//            // Reset the water and goal for the new day
//            currentWater = 0
//            waterHeight = 0
//        }
//    }
//}
//
