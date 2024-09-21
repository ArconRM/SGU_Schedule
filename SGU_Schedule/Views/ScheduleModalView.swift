//
//  ScheduleModalView.swift
//  SGU_Schedule
//
//  Created by Артемий on 29.01.2024.
//

import SwiftUI

struct ScheduleModalView<ViewModel>: View where ViewModel: ScheduleViewModel {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appSettings: AppSettings
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var curHeight: CGFloat = (UIScreen.screenHeight - UIScreen.screenHeight * (UIDevice.isPhone ? 0.14 : 0.1)).rounded()
    private let minHeight: CGFloat = 250
    private let maxHeight: CGFloat = (UIScreen.screenHeight - UIScreen.screenHeight * (UIDevice.isPhone ? 0.14 : 0.1)).rounded()
    
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
                .onChange(of: viewModel.groupSchedule?.lessons) { newLessons in
                    if viewModel.groupSchedule != nil {
                        lessonsBySelectedDay = viewModel.groupSchedule!.lessons.filter { $0.weekDay == selectedDay }
                    }
                    if viewModel.currentEvent != nil {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            curHeight = minHeight
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
                .padding(.bottom)
                .onChange(of: selectedDay) { newDay in
                    if viewModel.groupSchedule != nil {
                        lessonsBySelectedDay = viewModel.groupSchedule!.lessons.filter { $0.weekDay == selectedDay }
                    }
                }
                .disabled(viewModel.isLoadingLessons)
                
                Spacer()
                
                if viewModel.groupSchedule == nil && networkMonitor.isConnected {
                    Text("Загрузка...")
                        .font(.system(size: 19, design: .rounded))
                        .bold()
                } else if viewModel.groupSchedule != nil {
                    ScrollView {
                        ForEach(1...8, id:\.self) { lessonNumber in
                            let lessonsByNumber = lessonsBySelectedDay.filter { $0.lessonNumber == lessonNumber }
                            if !lessonsByNumber.isEmpty {
                                //id нужен чтобы переебашивало все вью, иначе оно сохраняет его флаг
                                ScheduleSubview(lessons: lessonsByNumber)
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
    ScheduleModalView(viewModel: ViewModelWithParsingSGUFactory().buildScheduleViewModel())
        .environmentObject(AppSettings())
        .environmentObject(NetworkMonitor())
        .environmentObject(ViewsManager(viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), schedulePersistenceManager: GroupScheduleCoreDataManager(), groupPersistenceManager: GroupCoreDataManager(), isOpenedFromWidget: false))
}
