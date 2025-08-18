//
//  Views.swift
//  MyTestProject
//
//  Created by Kakha on 18.08.25.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    let title: String
    let width: CGFloat?
    let height: CGFloat
    let backgroundColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring()) {
                    isPressed = false
                }
            }
            action()
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding()
                .frame(width: width, height: height)
                .background(backgroundColor)
                .cornerRadius(10)
                .shadow(radius: 5)
                .scaleEffect(isPressed ? 0.95 : 1)
        }
    }
}
