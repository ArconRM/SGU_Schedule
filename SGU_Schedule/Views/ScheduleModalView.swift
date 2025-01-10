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

    @State private var lessonsBySelectedDay = [LessonDTO]()
    @State private var selectedDay: Weekdays = Date.currentWeekDayWithoutSundayAndWithEveningBeingNextDay

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
                        lessonsBySelectedDay = viewModel.groupSchedule!.lessons.filter { $0.weekDay == selectedDay }
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
                    } else if viewModel.loadedLessonsWithChanges {
                        VStack {
                            Text("Обновлено")
                                .padding(.top, -10)
                                .font(.system(size: 19, weight: .bold, design: .rounded))
                            Text("с изменениями")
                                .font(.system(size: 13, design: .rounded))
                        }
                        .foregroundColor(.green)
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

                Picker("", selection: $selectedDay) {
                    ForEach(Weekdays.allCases.dropLast(), id: \.self) { day in
                        Text(day.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: selectedDay) { _ in
                    if viewModel.groupSchedule != nil {
                        lessonsBySelectedDay = viewModel.groupSchedule!.lessons.filter { $0.weekDay == selectedDay }
                    }
                }

//                Text("\(Date.startOfCurrentWeek?.getDayAndMonthWordString() ?? "Ошибка") - \(Date.endOfCurrentWeek?.getDayAndMonthWordString() ?? "Ошибка")")
//                    .font(.system(size: 19, design: .rounded))
//                    .padding(.vertical, 5)

                Text(Date.getDayOfCurrentWeek(dayNumber: selectedDay.number)?.getDayAndMonthWordString() ?? "Хз")
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .padding(.vertical, 5)

                if viewModel.groupSchedule == nil && networkMonitor.isConnected {
                    Text("Загрузка...")
                        .font(.system(size: 19, design: .rounded))
                        .bold()
                } else if viewModel.groupSchedule != nil {
                    ScrollView {
                        ForEach(1...8, id: \.self) { lessonNumber in
                            let lessonsByNumber = lessonsBySelectedDay.filter { $0.lessonNumber == lessonNumber }
                            if !lessonsByNumber.isEmpty {
                                // id нужен чтобы переебашивало все вью, иначе оно сохраняет его флаг
                                ScheduleSubview(lessons: lessonsByNumber, subgroupsByLessons: viewModel.subgroupsByLessons)
                                    .environmentObject(networkMonitor)
                                    .environmentObject(viewsManager)
                                    .id(UUID())
                            }
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 50)
                    }
                    .onAppear {
                        lessonsBySelectedDay = viewModel.groupSchedule!.lessons.filter { $0.weekDay == selectedDay }
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
    ScheduleModalView(viewModel: ViewModelWithParsingSGUFactory().buildScheduleViewModel())
        .environmentObject(AppSettings())
        .environmentObject(NetworkMonitor())
        .environmentObject(ViewsManager(appSettings: AppSettings(), viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), groupSchedulePersistenceManager: GroupScheduleCoreDataManager(), groupSessionEventsPersistenceManager: GroupSessionEventsCoreDataManager(), groupPersistenceManager: GroupCoreDataManager()))
}
