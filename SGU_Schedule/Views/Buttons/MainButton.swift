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
                    (colorScheme == .light ? Color.white : Color.gray.opacity(0.4))
                        .cornerRadius(10)
                        .blur(radius: 2)
                }
                    .background (
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colorScheme == .light ? .white : .clear)
                            .shadow(color: colorScheme == .light ? .gray.opacity(0.7) : .white.opacity(0.6), radius: 4)
                    )
            )
    }
}

#Preview {
    VStack(spacing: 20) {
        MainButton {
            Text("Бакалавриат/Армия не вариант")
                .padding(7)
                .font(.system(size: 17, weight: .bold))
        }
        MainButton {
            Image(systemName: "gear")
                .font(.system(size: 25, weight: .semibold))
        }
    }
}
