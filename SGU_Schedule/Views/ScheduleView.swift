//
//  ScheduleView.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI
import UIKit

struct ScheduleView<ViewModel>: View where ViewModel: ScheduleViewModel {
    
    @State var selectedGroup: Group
    
    @ObservedObject var viewModel: ViewModel
    
    var body : some View {
        ZStack(alignment: .bottom) {
            ScheduleBackView(selectedGroup: selectedGroup, viewModel: viewModel)
            ScheduleModuleView(viewModel: viewModel, selectedGroup: selectedGroup)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            viewModel.fetchUpdateDate(groupNumber: selectedGroup.fullNumber)
            viewModel.fetchLessonsAndSetCurrentAndTwoNextLessons(groupNumber: selectedGroup.fullNumber)
        }
    }
}

struct ScheduleBackView<ViewModel>: View  where ViewModel: ScheduleViewModel {
    
    @State var selectedGroup: Group
    
    @ObservedObject var viewModel: ViewModel
    
    var body : some View {
        VStack {
            Text(selectedGroup.shortName)
                .font(.custom("arial", size: 33))
                .bold()
                .padding(.top, -20)
            
            Text("Сейчас:")
                .font(.system(size: 20, weight: .bold))
                .padding()
            
            if let lesson = viewModel.currentEvent as? Lesson {
                Text(lesson.timeStart.getHoursAndMinutesString() + " - " +
                     lesson.timeEnd.getHoursAndMinutesString() + " " +
                     lesson.title)
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(lesson.lessonType.rawValue)
                    .padding(.top, 2)
                    .padding(.bottom, 10)
                    .font(.system(size: 17, weight: .bold))

                Text(lesson.cabinet)
                    .font(.system(size: 20, weight: .bold))
                    .bold()
            } else if let timeBreak = viewModel.currentEvent as? TimeBreak {
                Text(timeBreak.timeStart.getHoursAndMinutesString() + " - " +
                     timeBreak.timeEnd.getHoursAndMinutesString())
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(timeBreak.title)
                    .font(.system(size: 20, weight: .bold))
                
            } else {
                Text("-")
                    .font(.system(size: 20, weight: .bold))
            }
            
            Divider()
            
            Text("Далее:")
                .font(.system(size: 19, weight: .semibold))
                .padding()
            
            HStack {
                if viewModel.nextTwoLessons.count >= 2 {
                    VStack {
                        if let nextLesson1 = viewModel.nextTwoLessons[0] {
                            Text(nextLesson1.timeStart.getHoursAndMinutesString() + "-" +
                                 nextLesson1.timeEnd.getHoursAndMinutesString() + " " +
                                 nextLesson1.title)
                            .font(.system(size: 17, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            
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
                        if let nextLesson2 = viewModel.nextTwoLessons[1] {
                            Text(nextLesson2.timeStart.getHoursAndMinutesString() + "-" +
                                 nextLesson2.timeEnd.getHoursAndMinutesString() + " " +
                                 nextLesson2.title)
                            .font(.system(size: 17, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            
                            Text(nextLesson2.cabinet)
                                .padding()
                                .font(.system(size: 15, weight: .semibold))
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct ScheduleModuleView<ViewModel>: View where ViewModel: ScheduleViewModel {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var curHeight: CGFloat = UIScreen.screenHeight - 115
    let minHeight: CGFloat = 250
    let maxHeight: CGFloat = UIScreen.screenHeight - 115
//    let maxHeightWithoutCurrentLessonText: CGFloat = 530
    
    @State var selectedGroup: Group
    
    @State var showsAlert = false
    @State var selectedDay: Weekdays = Date.currentWeekDay
    @State var lessonsBySelectedDay = [[Lesson]]()
    
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
                
                if (viewModel.isLoadingUpdateDate) {
                    Text("Загрузка...")
                        .padding(.top, -10)
                        .font(.custom("arial", size: 19))
                        .bold()
                } else {
                    Text("Обновлено: " + viewModel.updateDate.getDayAndMonthString())
                        .padding(.top, -10)
                        .font(.custom("arial", size: 19))
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
                    lessonsBySelectedDay = viewModel.lessonsByDays[newDay.number - 1]
                }
                .disabled(viewModel.isLoadingLessons)
                
                Spacer()
                
                if viewModel.isLoadingLessons {
                    Text("Загрузка...")
                        .font(.custom("arial", size: 19))
                        .bold()
                } else {
                    ScrollView {
                        ForEach(lessonsBySelectedDay, id:\.self) { lessons in
                            ScheduleSubview(lessons: lessons)
                                .padding(.bottom, 5)
                        }
                        .padding(.bottom, 20)
                    }
                    .onAppear {
                        lessonsBySelectedDay = viewModel.lessonsByDays[selectedDay.number - 1]
                    }
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
        .alert(isPresented: $showsAlert) {
            Alert(title: Text("Fuck"))
        }
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
                            withAnimation(.easeInOut(duration: 1)) {
                                curHeight = minHeight
                            }
                        } 
//                        else if curHeight == maxHeightWithoutCurrentLessonText {
//                            withAnimation(.easeInOut(duration: 1.5)) {
//                                curHeight = minHeight
//                            }
//                        }
                        
                    } else { //вверх
                        if curHeight == minHeight {
                            withAnimation(.easeInOut(duration: 1)) {
                                curHeight = maxHeight
                            }
                        } 
//                        else if curHeight == maxHeightWithoutCurrentLessonText {
//                            withAnimation(.easeInOut(duration: 1.5)) {
//                                curHeight = maxHeight
//                            }
//                        }
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
        ScheduleView(selectedGroup: Group(fullNumber: 141), viewModel: ScheduleViewModelWithParsingSGU())
//            .colorScheme(.dark)
    }
}
