//
//  MeasurementColumn.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//
import SwiftUI

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
