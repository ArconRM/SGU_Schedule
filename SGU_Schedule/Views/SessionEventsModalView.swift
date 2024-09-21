//
//  SessionEventsModalView.swift
//  SGU_Schedule
//
//  Created by Артемий on 29.01.2024.
//

import SwiftUI

struct SessionEventsModalView<ViewModel>: View where ViewModel: ScheduleViewModel {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var appSettings: AppSettings
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var curHeight: CGFloat = (UIScreen.screenHeight - UIScreen.screenHeight * (UIDevice.isPhone ? 0.14 : 0.1)).rounded()
    private let minHeight: CGFloat = 250
    private let maxHeight: CGFloat = (UIScreen.screenHeight - UIScreen.screenHeight * (UIDevice.isPhone ? 0.14 : 0.1)).rounded()
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Capsule()
                        .opacity(0.3)
                        .frame(width: 40, height: 6)
                }
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background (Color.white.opacity (0.00001))
                .gesture(dragGesture)
                
                if networkMonitor.isConnected {
                    if viewModel.isLoadingSessionEvents {
                        Text("Не обновлено")
                            .padding(.top, -10)
                            .font(.system(size: 19, weight: .bold, design: .rounded))
                    } else {
                        Text("Обновлено")
                            .padding(.top, -10)
                            .font(.system(size: 19, weight: .bold, design: .rounded))
                    }
                } else {
                    Text("Нет соединения с интернетом")
                        .padding(.top, -10)
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                }
                
                if networkMonitor.isConnected {
                    if viewModel.isLoadingSessionEvents {
                        Text("Загрузка...")
                            .padding(.top, -10)
                            .font(.system(size: 19, weight: .bold, design: .rounded))
                    } else if viewModel.groupSessionEvents != nil {
                        ScrollView {
                            ForEach(
                                viewModel.groupSessionEvents!.sessionEvents.filter ({ $0.date.isAroundNow() }) +
                                viewModel.groupSessionEvents!.sessionEvents.filter ({ $0.date.inFuture() }) +
                                viewModel.groupSessionEvents!.sessionEvents.filter ({ $0.date.passed() }), id:\.self
                            ) { sessionEvent in
                                SessionEventSubview(sessionEvent: sessionEvent)
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 50)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .frame(height: curHeight)
        .background (
            ZStack {
                AppTheme(rawValue: appSettings.currentAppTheme)?.backgroundColor(colorScheme: colorScheme)
                    .cornerRadius(35)
                    .blur(radius: 2)
                    .ignoresSafeArea()
            }
                .background(
                    RoundedRectangle(cornerRadius: 35)
                        .fill(colorScheme == .light ? .white : .black)
                        .shadow(color: .gray.opacity(0.15), radius: 2, x: 0, y: -5))
        )
    }
    
    @State private var prevDragTrans = CGSize.zero
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .onChanged { value in
                let dragAmount = value.translation.height - prevDragTrans.height
                if curHeight > maxHeight {
                    curHeight = maxHeight
                } else if curHeight < minHeight {
                    curHeight = minHeight
                } else {
                    if dragAmount > 0 { //вниз
                        if curHeight == maxHeight {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                curHeight = minHeight
                            }
                        }
                        
                    } else { //вверх
                        if curHeight == minHeight {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                curHeight = maxHeight
                            }
                        }
                    }
                }
                prevDragTrans = value.translation
            }
            .onEnded { value in
                prevDragTrans = .zero
            }
    }
}

#Preview {
    SessionEventsModalView(viewModel: ViewModelWithParsingSGUFactory().buildScheduleViewModel())
        .environmentObject(NetworkMonitor())
        .environmentObject(AppSettings())
}
