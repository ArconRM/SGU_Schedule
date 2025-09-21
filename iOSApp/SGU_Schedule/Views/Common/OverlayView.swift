//
//  OverlayView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 16.10.2024.
//

import SwiftUI

struct OverlayView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore
    
    @Binding var isShowing: Bool
    @ViewBuilder let content: Content
    
    @State private var widgetsViewOpacity = 0.2
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.4)) {
                        isShowing.toggle()
                    }
                }
            
            Group {
                if #available(iOS 26, *) {
                    VStack {
                        closeButton
                        content
                            .opacity(widgetsViewOpacity)
                            .animation(.easeIn(duration: 0.4), value: widgetsViewOpacity)
                    }
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .glassEffect(
                        .regular.interactive(),
                        in: RoundedRectangle(cornerRadius: 20)
                    )
                } else {
                    VStack {
                        closeButton
                        content
                            .opacity(widgetsViewOpacity)
                            .animation(.easeIn(duration: 0.4), value: widgetsViewOpacity)
                    }
                    .padding()
                    .background(
                        ZStack {
                            appearanceSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme)
                                .cornerRadius(20)
                                .blur(radius: 2)
                                .ignoresSafeArea()
                        }
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(colorScheme == .light ? .white : .black)
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.gray.opacity(0.4))
                                    .blur(radius: 0.5)
                            }
                    )
                }
            }
            .padding()
            .padding(.bottom)
        }
        .onAppear {
            widgetsViewOpacity = 1
        }
    }
    
    private var closeButton: some View {
        HStack {
            Button(action: {
                withAnimation(.easeOut(duration: 0.4)) {
                    isShowing.toggle()
                }
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
                    .padding(.top, 15)
                    .padding(.leading, 15)
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
            }
            Spacer()
        }
    }
    
}

#Preview {
    OverlayView(isShowing: .constant(true)) {
        Text("fuck\nf\nf\n\n\n\n\n\n")
    }
    .environmentObject(AppearanceSettingsStore())
}
