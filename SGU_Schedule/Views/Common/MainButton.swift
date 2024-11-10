//
//  MainButton.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 15.09.2024.
//

import SwiftUI

struct MainButton<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ViewBuilder let content: Content
    
    var body: some View {
        content
            .foregroundColor(colorScheme == .light ? .black : .white)
            .background (
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .light ? .white.opacity(0.6) : .gray.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(colorScheme == .light ? .black.opacity(0.2) : .gray.opacity(0.4))
                        .blur(radius: 0.5)
                })
    }
}

#Preview {
    ZStack(alignment: .top) {
        Color.blue.opacity(0.1)
            .ignoresSafeArea()
        
        HStack(spacing: 20) {
            MainButton {
                Image(systemName: "gear")
                    .padding(10)
                    .font(.system(size: 25, weight: .semibold))
            }
            
            MainButton {
                Text("Бакалавриаттттттттт")
                    .padding(10)
                    .font(.system(size: 17, weight: .bold))
            }
            MainButton {
                Image(systemName: "gear")
                    .padding(10)
                    .font(.system(size: 25, weight: .semibold))
            }
        }
    }
}
