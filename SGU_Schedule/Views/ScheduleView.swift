//
//  ScheduleView.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI
import UIKit

struct ScheduleView<ViewModel>: View where ViewModel: ScheduleViewModel {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @ObservedObject var viewModel: ViewModel
    
    @State var selectedGroup: GroupDTO
    @Binding var favoriteGroupNumber: Int?
    
    var body : some View {
        ZStack(alignment: .bottom) {
            ScheduleBackView(selectedGroup: selectedGroup, viewModel: viewModel)
            ScheduleModuleView(viewModel: viewModel, selectedGroup: selectedGroup)
                .environmentObject(networkMonitor)
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    if viewModel.favoriteGroupNumber != selectedGroup.fullNumber {
                        viewModel.favoriteGroupNumber = selectedGroup.fullNumber
                        favoriteGroupNumber = viewModel.favoriteGroupNumber
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Label("Добавить в избранное", systemImage: favoriteGroupNumber == selectedGroup.fullNumber ? "star.fill" : "star")
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            viewModel.fetchUpdateDateAndLessons(groupNumber: selectedGroup.fullNumber, isOnline: networkMonitor.isConnected)
        }
        .alert(isPresented: $viewModel.isShowingError) {
            Alert(title: Text(viewModel.activeError?.errorDescription ?? "Error"),
                  message: Text(viewModel.activeError?.failureReason ?? "Unknown"))
        }
    }
}



struct ScheduleBackView<ViewModel>: View  where ViewModel: ScheduleViewModel {
    
    @State var selectedGroup: GroupDTO
    
    @ObservedObject var viewModel: ViewModel
    
    var body : some View {
        VStack {
            Text(selectedGroup.shortName)
                .font(.custom("arial", size: 30))
                .bold()
                .padding(.top, -20)
            
            Text("Сейчас:")
                .font(.system(size: 20, weight: .bold))
                .padding()
            
            if let lesson = viewModel.currentEvent as? LessonDTO {
                Text(lesson.timeStart.getHoursAndMinutesString() + " - " +
                     lesson.timeEnd.getHoursAndMinutesString() + " " +
                     lesson.title)
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 5)
                
                Text(lesson.lessonType.rawValue)
                    .padding(.top, 2)
                    .padding(.bottom, 10)
                    .font(.system(size: 17, weight: .bold))
                    .padding(.horizontal, 5)

                Text(lesson.cabinet)
                    .font(.system(size: 20, weight: .bold))
                    .bold()
                    .padding(.horizontal, 5)
                
            } else if let timeBreak = viewModel.currentEvent as? TimeBreakDTO {
                Text(timeBreak.timeStart.getHoursAndMinutesString() + " - " +
                     timeBreak.timeEnd.getHoursAndMinutesString())
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 5)
                
                Text(timeBreak.title)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal, 5)
                
            } else {
                Text("-")
                    .font(.system(size: 20, weight: .bold))
            }
            
            Divider()
            
            Text("Далее:")
                .font(.system(size: 19, weight: .semibold))
                .padding()
            
            HStack {
                VStack {
                    if let nextLesson1 = viewModel.nextLesson1 {
                        Text(nextLesson1.timeStart.getHoursAndMinutesString() + "-" +
                             nextLesson1.timeEnd.getHoursAndMinutesString() + " " +
                             nextLesson1.title)
                        .font(.system(size: 17, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                        
                        Text(nextLesson1.cabinet)
                            .padding()
                            .font(.system(size: 15, weight: .semibold))
                            .multilineTextAlignment(.center)
                    } else {
                        Text("-")
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                
                VStack {
                    if let nextLesson2 = viewModel.nextLesson2 {
                        Text(nextLesson2.timeStart.getHoursAndMinutesString() + "-" +
                             nextLesson2.timeEnd.getHoursAndMinutesString() + " " +
                             nextLesson2.title)
                        .font(.system(size: 17, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                        
                        Text(nextLesson2.cabinet)
                            .padding()
                            .font(.system(size: 15, weight: .semibold))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            Spacer()
        }
    }
}



struct ScheduleModuleView<ViewModel>: View where ViewModel: ScheduleViewModel {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var curHeight: CGFloat = UIScreen.screenHeight - 120
    private let minHeight: CGFloat = 250
    private let maxHeight: CGFloat = UIScreen.screenHeight - 120
    
    @State private var lessonsBySelectedDay = [LessonDTO]()
    @State private var selectedDay: Weekdays = Date.currentWeekDayWithoutSundayAndWithEveningBeingNextDay
    @State var selectedGroup: GroupDTO
    
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
                .onChange(of: viewModel.schedule?.lessons) { newLessons in
                    if viewModel.currentEvent != nil {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            curHeight = minHeight
                        }
                    }
                }
//                .onChange(of: viewModel.isLoadingLessons) { newValue in
//                    if newValue {
//                        viewModel.fetchUpdateDateAndLessons(groupNumber: selectedGroup.fullNumber, isOnline: networkMonitor.isConnected)
//                    }
//                }
                
                if networkMonitor.isConnected {
                    if viewModel.isLoadingUpdateDate {
                        Text("Загрузка...")
                            .padding(.top, -10)
                            .font(.system(size: 19, design: .rounded))
                            .bold()
                    } else {
                        Text("Обновлено: " + viewModel.updateDate.getDayAndMonthString())
                            .padding(.top, -10)
                            .font(.system(size: 19, design: .rounded))
                            .bold()
                    }
                } else {
                    Text("Нет соединения с интернетом")
                        .padding(.top, -10)
                        .font(.system(size: 19, design: .rounded))
                        .bold()
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
                    if viewModel.schedule != nil {
                        lessonsBySelectedDay = viewModel.schedule!.lessons.filter { $0.weekDay == selectedDay }
                    }
                }
                .disabled(viewModel.isLoadingLessons)
                
                Spacer()
                
                if viewModel.isLoadingLessons && networkMonitor.isConnected {
                    Text("Загрузка...")
                        .font(.system(size: 19, design: .rounded))
                        .bold()
                } else if viewModel.schedule != nil && !viewModel.schedule!.lessons.isEmpty {
                    ScrollView {
                        ForEach(1...8, id:\.self) { lessonNumber in
                            let lessonsByNumber = lessonsBySelectedDay.filter { $0.lessonNumber == lessonNumber }
                            if !lessonsByNumber.isEmpty {
                                ScheduleSubview(lessons: lessonsByNumber)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .onAppear {
                        lessonsBySelectedDay = viewModel.schedule!.lessons.filter { $0.weekDay == selectedDay }
                    }
                } else if !networkMonitor.isConnected {
                    Text("Нет соединения с интернетом")
                        .padding(.top, -10)
                        .font(.system(size: 19, design: .rounded))
                        .bold()
                }
                
                Spacer()
            }
        }
        .frame(height: curHeight)
        .background (
            ZStack {
                if colorScheme == .light {
                    LinearGradient(
                        colors: [.blue.opacity(0.1), .white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .cornerRadius(35)
                    .blur(radius: 2)
                    .ignoresSafeArea()
                } else {
                    LinearGradient(
                        colors: [.blue.opacity(0.15), .black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .cornerRadius(35)
                    .blur(radius: 2)
                    .ignoresSafeArea()
                }
            }
                .background(
                    RoundedRectangle(cornerRadius: 35)
                        .fill(colorScheme == .light ? .white : .black)
                        .shadow(color: .gray.opacity(0.15), radius: 6, x: 0, y: -5))
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
                            withAnimation(.easeInOut(duration: 0.5)) {
                                curHeight = minHeight
                            }
                        }
                        
                    } else { //вверх
                        if curHeight == minHeight {
                            withAnimation(.easeInOut(duration: 0.5)) {
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

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: ScheduleViewModelWithParsingSGU(), selectedGroup: GroupDTO(fullNumber: 141), favoriteGroupNumber: .constant(141))
//            .colorScheme(.dark)
    }
}
