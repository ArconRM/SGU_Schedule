//
//  ScheduleView.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI
import UIKit

struct ScheduleView: View {
    var body : some View {
        ZStack(alignment: .bottom) {
            ScheduleBackView()
            ScheduleModuleView()
                .environmentObject(ScheduleViewModelWithParsing(networkManager: NetworkManagerWithParsingSGU(endPoint: ScheduleURLSource())))
                .frame(height: 680)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ScheduleBackView: View {
    var body : some View {
        VStack {
            Text("МОАИС")
                .font(.custom("arial", size: 33))
                .bold()
                .padding(.top, -20)
            
            Spacer()
        }
    }
}

struct ScheduleModuleView: View {
    
    @State var showsAlert = false
    @State var selectedDay: Weekdays = getTodaysDay()
    @State var lessonsBySelectedDay: [[Lesson]] = []
    
    @EnvironmentObject var viewModel: ScheduleViewModelWithParsing
    
    var body: some View {
        ZStack {
            VStack {
                if (viewModel.isLoadingUpdateDate) {
                    Text("Загрузка...")
                        .padding(.top)
                        .font(.custom("arial", size: 19))
                        .bold()
                } else {
                    Text("Обновлено: " + viewModel.updateDate.getDayAndMonthString())
                        .padding(.top)
                        .font(.custom("arial", size: 19))
                        .bold()
                }
                
                Picker("", selection: $selectedDay) {
                    ForEach(Weekdays.allCases, id: \.self) { day in
                        Text(day.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
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
                            LessonSubview(lessons: lessons)
                                .cornerRadius(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white)
                                        .shadow(color: .gray, radius: 2, x: 0, y: 0))
                                .padding(.horizontal, 13)
                                .padding(.top, 5)
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
        .background (
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.07), .white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(40)
            }
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)
                        .shadow(color: .gray, radius: 6, x: 0, y: -2))
        )
        
        .onAppear {
            DispatchQueue.main.async {
                viewModel.fetchUpdateDate(groupNumber: 141)
                viewModel.fetchAllLessons(groupNumber: 141)
            }
        }
        .alert(isPresented: $showsAlert) {
            Alert(title: Text("Fuck"))
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
        //            .environmentObject(ScheduleViewModelWithParsing(networkManager: NetworkManagerWithParsingSGU(endPoint: ScheduleURLSource())))
    }
}
