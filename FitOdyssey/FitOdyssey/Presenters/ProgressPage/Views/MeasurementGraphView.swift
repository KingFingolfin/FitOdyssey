//
//  MeasurementGraphView.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//

import SwiftUI
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
            
//            Picker("Measurement", selection: $selectedMeasurement) {
//                ForEach(["Biceps", "Chest", "Waist", "Shoulders", "Weight"], id: \.self) { measurement in
//                    Text(measurement).tag(measurement)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
            
            CustomSegmentedPicker(selectedOption: $selectedMeasurement, options: ["Biceps", "Chest", "Waist", "Shoulders", "Weight"])

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
                            colors: [.blue, .appOrange],
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
                        .fill(Color.appTabbarBack.opacity(0.2))
                )
            }
        }
    }
}
