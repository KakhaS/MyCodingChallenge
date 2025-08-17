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
    @State private var currentWeatherType: WeatherType = .unknown
    
    
    
    var body: some View {
        ZStack {
            currentWeatherType.background
                    .ignoresSafeArea()
                    .animation(.easeInOut, value: currentWeatherType)
            VStack {
                Image(systemName: currentWeatherType.symbol)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .padding(30)
                    .animation(.easeInOut, value: currentWeatherType)
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
                    .padding(30)
                Button {
                    if !cityName.isEmpty {
                        fetchWeather(for: cityName) { info, type  in
                            weatherInfo = info
                            currentWeatherType = type
                        }
                    }
                } label: {
                    Text("Show Weather")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: textWidth, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
                
                Button {
                    cityName = ""
                } label: {
                    Text("Clear Cityname")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: textWidth, height: 50)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    //                    .animation(.easeInOut(duration: 0.3), value: textWidth) Animation 1
                    //                    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0), value: textWidth) Animation 2
                        .animation(.linear(duration: 0.3), value: textWidth)
                }
            }
            .padding()
        }
    }
    func fetchWeather(for city: String, completion: @escaping (String, WeatherType) -> Void) {
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityQuery)&appid=69aadee7d4e41d76919edfe23d9dd979&units=metric"
        
        guard let url = URL(string: urlString) else {
            completion("URL is not correct", .unknown)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _ , error in
            if let error = error {
                DispatchQueue.main.async {
                    completion("Error: \(error.localizedDescription)", .unknown)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion("NoData", .unknown)
                }
                return
            }
            do {
                let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let info = "\(decoded.name): \(Int(decoded.main.temp))°C, \(decoded.weather.first?.description ?? "")"
                let type = WeatherType(rawValue: decoded.weather.first?.main ?? "Unknown") ?? .unknown
                completion(info, type)
                
            }
            catch {
                DispatchQueue.main.async {
                    completion("Failed To decode JSON", .unknown)
                }
            }
            
        }.resume()
    }
}

#Preview {
    ContentView()
}
