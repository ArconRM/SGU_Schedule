//
//  TeacherInfoView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 28.05.2024.
//

import SwiftUI
import UIKit

struct TeacherInfoView<ViewModel>: View, Equatable where ViewModel: TeacherInfoViewModel {
    //чтобы не вью не переебашивалось при смене темы (и также источника инета)
    static func == (lhs: TeacherInfoView<ViewModel>, rhs: TeacherInfoView<ViewModel>) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appSettings: AppSettings
    
    @ObservedObject var viewModel: ViewModel
    
    var teacherEndpoint: String
    
    @State private var selectedTeacherScheduleVariant: TeacherSchedulePickerVariants = .Lessons
    @State private var selectedDay: Weekdays = Date.currentWeekDayWithoutSundayAndWithEveningBeingNextDay
    @State private var lessonsBySelectedDay = [LessonDTO]()
    
    private enum TeacherSchedulePickerVariants: String, CaseIterable {
        case Lessons = "Занятия"
        case Session = "Сессия"
    }
    
    var body : some View {
        if UIDevice.isPhone {
            NavigationView {
                buildUI()
            }
        } else if UIDevice.isPad {
            buildUI()
        }
    }
    
    private func buildUI() -> some View {
        ZStack {
            AppTheme(rawValue: appSettings.currentAppTheme)?.backgroundColor(colorScheme: colorScheme)
                .ignoresSafeArea()
                .shadow(radius: 5)
            
            if viewModel.isLoadingTeacherInfo {
                ProgressView()
            } else {
                ScrollView {
                    // TODO: Опять !
                    TeacherInfoCardView(teacher: self.viewModel.teacher!)
                        .padding(.horizontal, 10)
                        .padding(.top, 5)
                    
                    Picker("", selection: $selectedTeacherScheduleVariant) {
                        ForEach(TeacherSchedulePickerVariants.allCases, id: \.self) { variant in
                            Text(variant.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if selectedTeacherScheduleVariant == .Lessons {
                        if viewModel.isLoadingTeacherLessons {
                            ProgressView()
                        } else {
                            Picker("", selection: $selectedDay) {
                                ForEach(Weekdays.allCases.dropLast(), id: \.self) { day in
                                    Text(day.rawValue)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                            .padding(.bottom)
                            .onChange(of: selectedDay) { newDay in
                                lessonsBySelectedDay = viewModel.teacherLessons.filter { $0.weekDay == selectedDay }
                            }
                            
                            ScrollView(.vertical, showsIndicators: false) {
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
                                .padding(.bottom, 30)
                            }
                            .onAppear {
                                lessonsBySelectedDay = viewModel.teacherLessons.filter { $0.weekDay == selectedDay }
                            }
                        }
                    } else if selectedTeacherScheduleVariant == .Session {
                        if viewModel.isLoadingTeacherSessionEvents {
                            ProgressView()
                        } else {
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach(viewModel.teacherSessionEvents.filter ({ $0.date >= Date() }) + viewModel.teacherSessionEvents.filter ({ $0.date < Date() }), id:\.self) { sessionEvent in
                                    SessionEventSubview(sessionEvent: sessionEvent)
                                }
                                .padding(.top, 5)
                                .padding(.bottom, 30)
                            }
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        
        .onAppear {
            self.viewModel.fetchTeacherInfo(teacherEndpoint: self.teacherEndpoint)
        }
        
        .toolbar {
            makeCloseToolbarItem()
        }
        
        .alert(isPresented: $viewModel.isShowingError) {
            Alert(title: Text(viewModel.activeError?.errorDescription ?? "Error"),
                  message: Text(viewModel.activeError?.failureReason ?? "Unknown"))
        }
    }
    
    private func makeCloseToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: {
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewsManager.showScheduleView()
                }
            }) {
                Image(systemName: "multiply")
                    .font(.system(size: 23, weight: .semibold))
                    .padding(7)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .background (
                        ZStack {
                            (colorScheme == .light ? Color.white : Color.gray.opacity(0.4))
                                .cornerRadius(5)
                                .blur(radius: 2)
                                .ignoresSafeArea()
                        }
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(colorScheme == .light ? .white : .clear)
                                    .shadow(color: colorScheme == .light ? .gray.opacity(0.7) : .white.opacity(0.2), radius: 4)))
                    .opacity(viewModel.isLoadingTeacherInfo ? 0.5 : 1)
            }
            .disabled(viewModel.isLoadingTeacherInfo)
        }
    }
}


struct TeacherInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherInfoView(viewModel: ViewModelWithParsingSGUFactory().buildTeacherInfoViewModel(),
                        teacherEndpoint: "")
        .environmentObject(NetworkMonitor())
        .environmentObject(ViewsManager(viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), schedulePersistenceManager: GroupScheduleCoreDataManager(), groupPersistenceManager: GroupCoreDataManager()))
    }
}

//teacher: TeacherDTO(
//    fullName: "Осипцев Михаил Анатольевич",
//    profileImageUrl: URL(string: "https://www.old1.sgu.ru/sites/default/files/styles/500x375_4x3/public/employee/facepics/7a630f4a70a5310d9152a3d5e5350a35/foto-1.jpg?itok=IILG1z3i")!,
//    email: "Osipcevm@gmail.com",
//    officeAddress: "9 учебный корпус СГУ, ком. 316",
//    workPhoneNumber: "+7 (8452) 51 - 55 - 37",
//    personalPhoneNumber: "",
//    birthdate: Date.now,
//    teacherLessonsUrl: URL(string: "https://www.sgu.ru/schedule/teacher/475")!,
//teacherSessionEventsUrl: URL(string: "https://www.sgu.ru/schedule/teacher/475#session")!,
