//
//  ContentView.swift
//  MyTestProject
//
//  Created by Kakha on 15.08.25.
//

import SwiftUI

struct ContentView: View {
    @State private var cityName: String = ""
    @State private var textWidth: CGFloat = 0
    @State private var weatherInfo: String = "Weather info will be displayed here..."
    
    
    
    var body: some View {
        VStack {
            TextField("Enter City...", text: $cityName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .onChange(of: cityName) { oldValue, newValue in
                    if !newValue.isEmpty {
                        weatherInfo = "Weather for \(newValue)"
                    } else {
                        weatherInfo = "Weather info will be displayed here..."
                    }
                }
            Text(weatherInfo)
                .font(.headline)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {textWidth = geo.size.width}
                            .onChange(of: geo.size.width) { oldWidth, newWidth in
                                textWidth = newWidth
                            }
                    }
                )
            Button("Show Weather")
            {
                if !cityName.isEmpty {
                    let temp = Int.random(in: 15...35)
                    weatherInfo = "\(cityName) : \(temp) C "
                }
            }
            
            Button {
                cityName = ""
            } label: {
                Text("Clear")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: textWidth)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
//                    .animation(.easeInOut(duration: 0.3), value: textWidth)
//                    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0), value: textWidth)
                    .animation(.linear(duration: 0.3), value: textWidth)
            }
            
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
