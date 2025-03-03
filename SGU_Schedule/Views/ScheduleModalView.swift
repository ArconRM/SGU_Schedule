//
//  ScheduleModalView.swift
//  SGU_Schedule
//
//  Created by Артемий on 29.01.2024.
//

import SwiftUI

// TODO: Объединить с модалом для сессии
struct ScheduleModalView<ViewModel>: View where ViewModel: ScheduleViewModel {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
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
                .onChange(of: viewModel.groupSchedule?.lessons) { _ in
                    if viewModel.groupSchedule != nil {
                        viewModel.updateScheduleEventsBySelectedDay()
                    }
                    if viewModel.currentEvent != nil {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            curPadding = maxPadding
                        }
                    }
                }

                if networkMonitor.isConnected {
                    if viewModel.isLoadingLessons {
                        Text("Не обновлено")
                            .padding(.top, -10)
                            .font(.system(size: 19, weight: .bold, design: .rounded))
                    } else {
                        VStack {
                            Text("Обновлено")
                                .padding(.top, -10)
                                .font(.system(size: 19, weight: .bold, design: .rounded))

                            if viewModel.loadedLessonsWithChanges {
                                Text("с изменениями")
                                    .font(.system(size: 13, design: .rounded))
                            }

                            if viewModel.currentEvent != nil {
                                if viewModel.currentActivities.isEmpty {
                                    Button("Добавить все следующие Live Activity") {
                                        for lessonNumber in 1...8 {
                                            viewModel.startAllTodaysActivitiesByLessonNumber(lessonNumber: lessonNumber)
                                        }

                                        let impact = UIImpactFeedbackGenerator(style: .medium)
                                        impact.impactOccurred()
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(appSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme))
                                } else {
                                    Button("Удалить все Live Activity") {
                                        for lessonNumber in 1...8 {
                                            viewModel.endAllActivities()
                                        }

                                        let impact = UIImpactFeedbackGenerator(style: .medium)
                                        impact.impactOccurred()
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(appSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme))
                                }
                            }
                        }
                    }
                } else {
                    Text("Нет соединения с интернетом")
                        .padding(.top, -10)
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                }

                Picker("", selection: $viewModel.selectedDay) {
                    ForEach(Weekdays.allCases.dropLast(), id: \.self) { day in
                        Text(day.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: viewModel.selectedDay) { _ in
                    viewModel.updateScheduleEventsBySelectedDay()
                }

                Text(Date.getDayOfCurrentWeek(dayNumber: viewModel.selectedDay.number)?.getDayAndMonthWordString() ?? "Хз")
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .padding(.vertical, 5)

                if viewModel.groupSchedule == nil && networkMonitor.isConnected {
                    Text("Загрузка...")
                        .font(.system(size: 19, design: .rounded))
                        .bold()
                } else if viewModel.groupSchedule != nil {
                    ScrollView {
                        ForEach(1...8, id: \.self) { lessonNumber in
                            let scheduleEventsByNumber = viewModel.getScheduleEventsBySelectedDayAndNumber(lessonNumber: lessonNumber)
                            if !scheduleEventsByNumber.isEmpty {
                                if scheduleEventsByNumber.count == 1, let window = scheduleEventsByNumber.first as? TimeBreak {
                                    ScheduleSubview(window: window, subgroupsByLessons: viewModel.subgroupsByLessons)
                                        .environmentObject(networkMonitor)
                                        .environmentObject(viewsManager)
                                        .id(UUID())
                                } else {
                                    ScheduleSubview(lessons: scheduleEventsByNumber as? [LessonDTO], subgroupsByLessons: viewModel.subgroupsByLessons)
                                        .environmentObject(networkMonitor)
                                        .environmentObject(viewsManager)
                                        .id(UUID())
                                }
                            }
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 50)
                    }
                    .onAppear {
                        viewModel.updateScheduleEventsBySelectedDay()
                    }
                } else {
                    Text("Нет соединения с интернетом")
                        .padding(.top, -10)
                        .font(.system(size: 19, weight: .bold, design: .rounded))
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
                        Image("patternImageRofl2")
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
    ScheduleModalView(viewModel: ViewModelWithMockDataFactory().buildScheduleViewModel())
        .environmentObject(AppSettings())
        .environmentObject(NetworkMonitor())
        .environmentObject(ViewsManagerWithMockDataFactory().makeViewsManager())
}
