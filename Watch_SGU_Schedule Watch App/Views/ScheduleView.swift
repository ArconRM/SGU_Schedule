//
//  ScheduleView.swift
//  Watch_SGU_Schedule Watch App
//
//  Created by Артемий on 17.11.2023.
//

import SwiftUI

struct ScheduleView<ViewModel>: View where ViewModel: ScheduleViewModel {
    @ObservedObject var viewModel: ViewModel
    
    //    @EnvironmentObject var networkMonitor: NetworkMonitor
    @Binding var selectedGroupNumber: Int?
    @State private var currentDay: Weekdays = Date.currentWeekDayWithoutSundayAndWithEveningBeingNextDay
    
    var body: some View {
        TabView {
            if viewModel.isLoadingLessons {
                Text("Загрузка...")
                    .font(.system(size: 16, weight: .bold))
                
            } else {
                VStack {
                    Text("Сейчас:")
                        .font(.system(size: 20, weight: .bold))
//                        .padding()
                    
                    if viewModel.currentEvent != nil {
                        EventSubview(event: viewModel.currentEvent!)
                    } else {
                        Text("-")
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                
                VStack {
                    Text("Далее:")
                        .font(.system(size: 19, weight: .semibold))
                        .padding()
                    
                    if let nextLesson1 = viewModel.nextLesson1 {
                        EventSubview(event: nextLesson1)
                    } else {
                        Text("-")
                            .font(.system(size: 20, weight: .bold))
                    }
                }
            }
            
            
            if viewModel.isLoadingLessons {
                Text("Загрузка...")
                    .font(.system(size: 16, weight: .bold))
                
            } else {
                if viewModel.schedule?.lessons.isEmpty ?? true || viewModel.schedule!.lessons.filter({ $0.weekDay == currentDay }).isEmpty {
                    Text("Сегодня кайфуешь")
                        .font(.system(size: 16, weight: .bold))
                    
                } else {
                    VStack {
                        Text(currentDay.rawValue)
                            .font(.system(size: 16, weight: .bold))
                            .padding(.top, 20)
                        
                        TabView {
                            ForEach(1...8, id:\.self) { lessonNumber in
                                let lessonsByNumber = viewModel.schedule!.lessons.filter { $0.weekDay == currentDay && $0.lessonNumber == lessonNumber }
                                if !lessonsByNumber.isEmpty {
                                    ScheduleSubview(lessons: lessonsByNumber)
                                }
                            }
                        }
                        .tabViewStyle(.carousel)
                    }
                    .ignoresSafeArea()
                }
            }
            
            Button {
                viewModel.clearStorage()
                selectedGroupNumber = nil
            } label: {
                Text("Сменить группу")
                    .font(.system(size: 15))
            }

        }
        .tabViewStyle(.page)
        .onAppear {
            viewModel.fetchUpdateDateAndLessons(groupNumber: selectedGroupNumber!, isOnline: true)
        }
    }
}



struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: ScheduleViewModelWithParsingSGU(), selectedGroupNumber: .constant(141))
    }
}
