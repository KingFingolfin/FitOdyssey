//
//  WheelNumberField.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//
import SwiftUI

struct WheelNumberField: View {
    let title: String
    @Binding var value: String
    let range: ClosedRange<Int>
    let unit: String
    @State private var isPickerShown = false
    @State private var selectedNumber: Int

    init(title: String, value: Binding<String>, range: ClosedRange<Int>, unit: String) {
        self.title = title
        self._value = value
        self.range = range
        self.unit = unit
        let initialValue = Int(value.wrappedValue) ?? range.lowerBound
        self._selectedNumber = State(initialValue: initialValue)
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(LocalizedStringKey(title))
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Button(action: {
                    isPickerShown = true
                }) {
                    HStack {
                        Text("\(value.isEmpty ? "--" : value) \(unit)")
                            .foregroundColor(value.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.appTextFieldBackGround)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal)

            if isPickerShown {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPickerShown = false
                    }

                VStack(spacing: 15) {
                    Text("Select \(title)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    Picker("", selection: $selectedNumber) {
                        ForEach(Array(range), id: \.self) { number in
                            Text("\(number) \(unit)")
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)

                    HStack {
                        Button("Cancel") {
                            isPickerShown = false
                        }
                        .foregroundColor(.red)
                        .padding()

                        Spacer()

                        Button("Done") {
                            value = String(selectedNumber)
                            isPickerShown = false
                        }
                        .foregroundColor(.blue)
                        .padding()
                    }
                }
                .padding()
                .frame(width: 320)
                .background(Color.black.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .transition(.scale)
            }
        }
        .animation(.easeInOut, value: isPickerShown)
    }
}
