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

    @State private var curPadding: CGFloat = 20
    @State private var maxPadding: CGFloat = UIScreen.getModalViewMaxPadding(initialOrientation: UIDevice.current.orientation, currentOrientation: UIDevice.current.orientation)
    private let minPadding: CGFloat = 20
    private let initialOrientation = UIDevice.current.orientation

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
                .background(Color.white.opacity(0.00001))
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

                if viewModel.groupSessionEvents == nil && networkMonitor.isConnected {
                    Text("Загрузка...")
                        .padding(.top, -10)
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                } else if viewModel.groupSessionEvents != nil {
                    ScrollView {
                        ForEach(
                            // Которые сегодня, но не закончились еще
                            viewModel.groupSessionEvents!.sessionEvents.filter({
                                $0.date.isToday() && !$0.date.passed(duration: Date.getDurationHours(sessionEventType: $0.sessionEventType))
                            }) +
                            
                            // Которые будут, но не сегодня
                            viewModel.groupSessionEvents!.sessionEvents.filter({
                                $0.date.inFuture() && !$0.date.isToday()
                            }) +

                            // Которые уже прошли
                            viewModel.groupSessionEvents!.sessionEvents.filter({
                                $0.date.passed(duration: Date.getDurationHours(sessionEventType: $0.sessionEventType))
                            }),

                            id: \.self
                        ) { sessionEvent in
                            SessionEventSubview(sessionEvent: sessionEvent)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 50)
                    }
                }

                Spacer()
            }
        }
        .onChange(of: viewModel.isLoadingLessons) { newValue in
            if !newValue {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
            }
        }

        .onRotate(perform: { newOrientation in
            maxPadding = UIScreen.getModalViewMaxPadding(initialOrientation: initialOrientation, currentOrientation: newOrientation)
            if curPadding != minPadding {
                curPadding = maxPadding
            }
        })

        .background(
            GeometryReader { geometry in
                ZStack {
                    appSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme)
                        .cornerRadius(35)
                        .blur(radius: 2)
                        .ignoresSafeArea()
                }
                .background(
                    RoundedRectangle(cornerRadius: 35)
                        .fill(colorScheme == .light ? .white : .black)
                        .shadow(color: .gray.opacity(0.15), radius: 2, x: 0, y: -5))
                .overlay {
                    if appSettings.currentAppTheme == .pinkHelloKitty {
                        Image("patternImageRofl")
                            .resizable()
                            .ignoresSafeArea()
                            .aspectRatio(contentMode: .fill) // Maintain aspect ratio
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            .clipped()
                            .opacity(colorScheme == .light ? 0.2 : 0.1)
                    }
                }
            }
        )
        .padding(.top, curPadding)
    }

    @State private var prevDragTrans = CGSize.zero

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .onChanged { value in
                let dragAmount = value.translation.height - prevDragTrans.height
                if curPadding > maxPadding {
                    curPadding = maxPadding
                } else if curPadding < minPadding {
                    curPadding = minPadding
                } else {
                    if dragAmount > 0 { // вниз
//                        if curPadding == minPadding {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                curPadding = maxPadding
                            }
//                        }

                    } else { // вверх
//                        if curPadding == maxPadding {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                curPadding = minPadding
                            }
//                        }
                    }
                }
                prevDragTrans = value.translation
            }
            .onEnded { _ in
                prevDragTrans = .zero
            }
    }
}

#Preview {
    SessionEventsModalView(viewModel: ViewModelWithParsingSGUFactory().buildScheduleViewModel())
        .environmentObject(NetworkMonitor())
        .environmentObject(AppSettings())
}
