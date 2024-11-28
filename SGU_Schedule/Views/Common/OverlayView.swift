//
//  OverlayView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 16.10.2024.
//

import SwiftUI

struct OverlayView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSettings: AppSettings

    @Binding var isShowing: Bool
    @ViewBuilder let content: Content

    @State private var widgetsViewOpacity = 0.2

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                (colorScheme == .light ?
                 Color.gray
                    .opacity(0.6) :
                    Color.black
                    .opacity(0.4))
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.4)) {
                        isShowing.toggle()
                    }
                }

                VStack {
                    HStack {
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.4)) {
                                isShowing.toggle()
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                                .padding(.top, 15)
                                .padding(.leading, 15)
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                        })

                        Spacer()
                    }

                    content
                        .opacity(widgetsViewOpacity)
                        .animation(.easeIn(duration: 0.4), value: widgetsViewOpacity)
                }
                .background(
                    ZStack {
                        appSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme)
                            .cornerRadius(20)
                            .blur(radius: 2)
                            .ignoresSafeArea()
                    }
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(colorScheme == .light ? .white : .black)
//                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 0)

                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.gray.opacity(0.4))
                                .blur(radius: 0.5)
                        }
                )
                .frame(width: geometry.size.width - 20, height: geometry.size.height * 0.7)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            widgetsViewOpacity = 1
        }
    }
}

#Preview {
    OverlayView(isShowing: .constant(true)) {
        Text("fuck")
    }
    .environmentObject(AppSettings())
}
