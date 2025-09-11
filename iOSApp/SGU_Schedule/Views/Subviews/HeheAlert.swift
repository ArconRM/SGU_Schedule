//
//  HeheAlert.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 01.10.2024.
//

import SwiftUI

struct HeheAlert: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var show: Bool

    var body: some View {
        ZStack {
            (colorScheme == .light ? Color.gray : Color.black)
                .opacity(0.4)
                .ignoresSafeArea()

            VStack {
                Text("Это не хомяк")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.top, 10)
                    .padding(.bottom, 5)

                Text("По лбу себе потыкай")
                    .font(.system(size: 23, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.top, 5)
                    .padding(.bottom, 20)

                Divider()

                withAnimation(.easeInOut(duration: 0.5)) {
                    Button("OK") {
                        withAnimation(.easeOut(duration: 0.1)) {
                            show.toggle()
                        }
                    }
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
                    .padding(5)
                }
            }
            .padding()
            .background(colorScheme == .light ? .white : .black)
            .cornerRadius(20)
            .scaleEffect(CGSize(width: 0.7, height: 0.7))
        }
    }
}

#Preview {
    ZStack {
        Color.red.ignoresSafeArea()

        HeheAlert(show: .constant(true))
    }
}
