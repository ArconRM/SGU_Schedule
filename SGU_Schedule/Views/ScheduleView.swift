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

struct ScheduleBackView<ViewModel>: View  where ViewModel: ScheduleViewModel{
    
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
            
            if viewModel.currentLesson != nil {
                Text(viewModel.currentLesson!.timeStart.getHoursAndMinutesString() + " - " +
                     viewModel.currentLesson!.timeEnd.getHoursAndMinutesString() + " " +
                     viewModel.currentLesson!.subject)
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .bold()
                
                Text(viewModel.currentLesson!.lessonType.rawValue)
                    .padding(.top, 2)
                    .padding(.bottom, 10)
                    .font(.system(size: 17, weight: .bold))
                
                Text(viewModel.currentLesson!.cabinet)
                    .font(.system(size: 20, weight: .bold))
                    .bold()
            } else {
                Text("-")
                    .font(.system(size: 20, weight: .bold))
                    .bold()
            }
            
            Divider()
            
            HStack {
                if viewModel.twoNextLessons[0] != nil {
                    VStack {
                        Text(viewModel.twoNextLessons[0]!.timeStart.getHoursAndMinutesString() + " - " + viewModel.twoNextLessons[0]!.timeEnd.getHoursAndMinutesString() + " " + viewModel.twoNextLessons[0]!.subject)
                            .font(.system(size: 18, weight: .bold))
                            .multilineTextAlignment(.center)
                            .bold()
                        
                        Text(viewModel.twoNextLessons[0]!.lessonType.rawValue)
                            .padding(.top, 2)
                            .padding(.bottom, 7)
                            .font(.system(size: 16, weight: .bold))
                        
                        Text(viewModel.twoNextLessons[0]!.cabinet)
                            .font(.system(size: 18, weight: .bold))
                            .bold()
                    }
                    .padding(.trailing, 10)
                }
                
                if viewModel.twoNextLessons[1] != nil {
                    VStack {
                        Text(viewModel.twoNextLessons[1]!.timeStart.getHoursAndMinutesString() + " - " + viewModel.twoNextLessons[1]!.timeEnd.getHoursAndMinutesString() + " " + viewModel.twoNextLessons[1]!.subject)
                            .font(.system(size: 18, weight: .bold))
                            .multilineTextAlignment(.center)
                            .bold()
                        
                        Text(viewModel.twoNextLessons[1]!.lessonType.rawValue)
                            .padding(.top, 2)
                            .padding(.bottom, 7)
                            .font(.system(size: 16, weight: .bold))
                        
                        Text(viewModel.twoNextLessons[1]!.cabinet)
                            .font(.system(size: 18, weight: .bold))
                            .bold()
                    }
                    .padding(.leading, 10)
                }
            }
            
            Spacer()
        }
    }
}

struct ScheduleModuleView<ViewModel>: View where ViewModel: ScheduleViewModel {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var curHeight: CGFloat = 680
    let minHeight: CGFloat = 200
    let maxHeight: CGFloat = 680
    
    @State var selectedGroup: Group
    
    @State var showsAlert = false
    @State var selectedDay: Weekdays = Date.getTodaysDay()
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
                    ForEach(Weekdays.allCases, id: \.self) { day in
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
//                            if lessonsBySelectedDay.last != lessons {
//                                Rectangle()
//                                    .fill(.blue)
//                                    .frame(height: 0.5)
//                                    .edgesIgnoringSafeArea(.horizontal)
//                            }
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
                        colors: [.blue.opacity(0.15), .white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .cornerRadius(35)
                    .blur(radius: 2)
                    .ignoresSafeArea()
                } else {
                    LinearGradient(
                        colors: [.blue.opacity(0.2), .black],
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
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                let dragAmount = value.translation.height - prevDragTrans.height
                if curHeight > maxHeight {
                    curHeight = maxHeight
                } else if curHeight < minHeight {
                    curHeight = minHeight
                } else {
                    curHeight -= dragAmount
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
        ScheduleView(selectedGroup: Group(fullNumber: 341), viewModel: ScheduleViewModelWithParsingSGU())
//            .colorScheme(.dark)
    }
}
