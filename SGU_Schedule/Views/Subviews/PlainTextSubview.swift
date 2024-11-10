//
//  PlainTextSubview.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 08.06.2024.
//

import SwiftUI

struct PlainTextSubview: View {
    @Environment(\.colorScheme) var colorScheme
    
    var department: Department
    
    var body: some View {
        VStack {
            HStack {
                Text(department.fullName)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .padding(20)
                
                Spacer()
            }
        }
        .cornerRadius(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .light ? .white : .white.opacity(0.2))
                .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                .blur(radius: 0.5)
        )
        .padding(.horizontal, 13)
        .frame(minHeight:50)
    }
}

#Preview {
    ZStack {
        Rectangle()
            .foregroundColor(.blue.opacity(0.1))
            .ignoresSafeArea()
        ScrollView {
            PlainTextSubview(department: Department(code: "knt"))
            PlainTextSubview(department: Department(code: "mm"))
        }
    }
}
