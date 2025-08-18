//
//  ContentView.swift
//  MyTestProject
//
//  Created by Kakha on 15.08.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            viewModel.currentWeatherType.background
                    .ignoresSafeArea()
                    .animation(.easeInOut, value: viewModel.currentWeatherType)
            VStack {
                Image(systemName: viewModel.currentWeatherType.symbol)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .padding(30)
                    .animation(.easeInOut, value: viewModel.currentWeatherType)
                TextField("Enter City...", text: $viewModel.cityName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .onChange(of: viewModel.cityName) { oldValue, newValue in
                        if !newValue.isEmpty {
                            viewModel.weatherInfo = "Weather for \(newValue)"
                        } else {
                            viewModel.weatherInfo = "Weather info will be displayed here..."
                        }
                    }
                Text(viewModel.weatherInfo)
                    .font(.headline)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {viewModel.textWidth = geo.size.width}
                                .onChange(of: geo.size.width) { oldWidth, newWidth in
                                    viewModel.textWidth = newWidth
                                }
                        }
                    )
                    .padding(30)
       
                
                CustomButton(title: "ShowWeather", width: viewModel.textWidth, height: 50, backgroundColor: Color.blue, action: {
                    Task {
                        let (info, type) = await viewModel.fetchWeatherAsync(for: viewModel.cityName)
                        await MainActor.run {
                            viewModel.weatherInfo = info
                            viewModel.currentWeatherType = type
                        }
                    }
                })
                .padding(15)
                
                CustomButton(title: "Clear City Name", width: viewModel.textWidth, height: 50, backgroundColor: Color.red) {
                    viewModel.cityName = ""
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
