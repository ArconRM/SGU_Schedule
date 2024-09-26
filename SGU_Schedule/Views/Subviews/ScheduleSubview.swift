//
//  ScheduleSubview.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI

struct ScheduleSubview: View, Equatable {
    static func == (lhs: ScheduleSubview, rhs: ScheduleSubview) -> Bool {
        return lhs.lessons == rhs.lessons
    }
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appSettings: AppSettings
    
    var lessons: [LessonDTO]
    
    @State var areMultipleLessonsCollapsed: Bool = true
    
    var body: some View {
        VStack {
            if lessons.count == 1 {
                makeSingleLessonView(lesson: lessons.first!)
            } else if lessons.count >= 1 {
                if areMultipleLessonsCollapsed {
                    makeCollapsedMultipleLessonsView(firstLesson: sortLessonsByWeekType(lessons).first!)
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.5)) {
                                areMultipleLessonsCollapsed.toggle()
                            }
                        }
                } else {
                    makeFullMultipleLessonsView(lessons: sortLessonsByWeekType(lessons))
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.5)) {
                                areMultipleLessonsCollapsed.toggle()
                            }
                        }
                }
            }
        }
        .background(colorScheme == .light ? Color.white : Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal, 13)
        .shadow(color: colorScheme == .light ?
                    .gray.opacity(0.3) :
                    .white.opacity(0.2),
                 radius: 3,
                 x: 0,
                 y: 0)
    }
    
    private func sortLessonsByWeekType(_ lessons: [LessonDTO]) -> [LessonDTO] {
        return lessons.filter({ Date.checkIfWeekTypeIsAllOrCurrent($0.weekType) }) + lessons.filter({ !Date.checkIfWeekTypeIsAllOrCurrent($0.weekType) })
    }
    
    private func makeSingleLessonView(lesson: LessonDTO) -> some View {
        VStack {
            HStack {
                Text("\(lesson.timeStart.getHoursAndMinutesString()) - \(lesson.timeEnd.getHoursAndMinutesString())")
                    .font(.system(size: 17))
                    .bold()
                
                if lesson.weekType != .All {
                    Text("(\(lesson.weekType.rawValue))")
                        .font(.system(size: 17))
                        .bold()
                }
                
                Spacer()
                
                Text(lesson.lessonType.rawValue)
                    .foregroundColor(getLessonColor(lesson: lesson))
                    .font(.system(size: 17))
                    .bold()
            }
            
            Text(lesson.title)
                .multilineTextAlignment(.center)
                .font(.system(size: 17, weight: .bold))
                .padding(.vertical, 7)
            
            HStack {
                if lesson.subgroup != nil && lesson.subgroup != "" {
                    Text("\(lesson.teacherFullName) \n\(lesson.subgroup!)")
                        .font(.system(size: 17))
                        .italic()
                        .underline(lesson.teacherEndpoint != nil)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if lesson.teacherEndpoint != nil && networkMonitor.isConnected {
                                    viewsManager.showTeacherInfoView(teacherEndpoint: lesson.teacherEndpoint!)
                                }
                            }
                        }
                    
                } else {
                    Text(lesson.teacherFullName)
                        .font(.system(size: 17))
                        .italic()
                        .underline(lesson.teacherEndpoint != nil)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if lesson.teacherEndpoint != nil && networkMonitor.isConnected {
                                    viewsManager.showTeacherInfoView(teacherEndpoint: lesson.teacherEndpoint!)
                                }
                            }
                        }
                }
                
                Spacer()
                
                Text("\(lesson.cabinet)")
                    .font(.system(size: 17))
                    .bold()
            }
        }
        .foregroundColor(colorScheme == .light ? .black : .white)
        .padding(15)
        .opacity(Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) ? 1 : 0.5)
        .background(getBackground(lesson: lesson))
    }
    
    private func makeFullMultipleLessonsView(lessons: [LessonDTO]) -> some View {
        ForEach(lessons, id:\.self) { lesson in
            VStack {
                HStack {
                    Text("\(lesson.timeStart.getHoursAndMinutesString()) - \(lesson.timeEnd.getHoursAndMinutesString())")
                        .font(.system(size: 17))
                        .bold()
                    
                    if lesson.weekType != .All {
                        Text("(\(lesson.weekType.rawValue))")
                            .font(.system(size: 17))
                            .bold()
                    }
                    
                    Spacer()
                    
                    Text(lesson.lessonType.rawValue)
                        .foregroundColor(getLessonColor(lesson: lesson))
                        .font(.system(size: 17))
                        .bold()
                }
                
                Text(lesson.title)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 17, weight: .bold))
                    .padding(.vertical, 7)
                
                HStack {
                    if lesson.subgroup != nil && lesson.subgroup != "" {
                        Text("\(lesson.teacherFullName) \n\(lesson.subgroup!)")
                            .font(.system(size: 17))
                            .italic()
                            .underline(lesson.teacherEndpoint != nil)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if lesson.teacherEndpoint != nil && networkMonitor.isConnected {
                                        viewsManager.showTeacherInfoView(teacherEndpoint: lesson.teacherEndpoint!)
                                    }
                                }
                            }
                        
                    } else {
                        Text(lesson.teacherFullName)
                            .font(.system(size: 17))
                            .italic()
                            .underline(lesson.teacherEndpoint != nil)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if lesson.teacherEndpoint != nil && networkMonitor.isConnected {
                                        viewsManager.showTeacherInfoView(teacherEndpoint: lesson.teacherEndpoint!)
                                    }
                                }
                            }
                    }
                    
                    Spacer()
                    
                    Text("\(lesson.cabinet)")
                        .font(.system(size: 17))
                        .bold()
                }
            }
            .foregroundColor(colorScheme == .light ? .black : .white)
            .padding(15)
            .opacity(Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) ? 1 : 0.5)
            .background {
                if AppStyle(rawValue: appSettings.currentAppStyle)! != .Bordered {
                    getBackground(lesson: lesson)
                }
            }
        }
    }
    
    private func makeCollapsedMultipleLessonsView(firstLesson lesson: LessonDTO) -> some View {
        VStack {
            HStack {
                Text("\(lesson.timeStart.getHoursAndMinutesString()) - \(lesson.timeEnd.getHoursAndMinutesString())")
                    .font(.system(size: 17))
                    .bold()
                
                if lesson.weekType != .All {
                    Text("(\(lesson.weekType.rawValue))")
                        .font(.system(size: 17))
                        .bold()
                }
                
                Spacer()
                
                Text(lesson.lessonType.rawValue)
                    .foregroundColor(getLessonColor(lesson: lesson))
                    .font(.system(size: 17))
                    .bold()
            }
            
            Text(lesson.title)
                .multilineTextAlignment(.center)
                .font(.system(size: 17, weight: .bold))
                .padding(.vertical, 7)
            
            HStack {
                if lesson.subgroup == nil || lesson.subgroup == "" {
                    Text(lesson.teacherFullName)
                        .font(.system(size: 17))
                        .italic()
                    
                    Spacer()
                    
                    Text("\(lesson.cabinet)")
                        .font(.system(size: 17))
                        .bold()
                }
            }
            
            Image(systemName: "chevron.down")
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 2)
        }
        .foregroundColor(colorScheme == .light ? .black : .white)
        .padding(15)
        .opacity(Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) ? 1 : 0.5)
        .background(getBackground(lesson: lesson))
    }
    
    private func getBackground(lesson: LessonDTO) -> AnyView {
        switch AppStyle(rawValue: appSettings.currentAppStyle)! {
        case .Fill:
            AnyView(
                getLessonColor(lesson: lesson).opacity(0.2)
            )
        case .Bordered:
            AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(getLessonColor(lesson: lesson).opacity(0.5), lineWidth: 7)
            )
        }
    }
    
    private func getLessonColor(lesson: LessonDTO) -> Color {
        Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) ?
        (lesson.lessonType == .Lecture ? Color.green : Color.blue)
        : Color.gray
    }
}

struct ScheduleSubview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.blue.opacity(0.07))
                .ignoresSafeArea()
            ScrollView {
                ScheduleSubview(lessons: [LessonDTO(subject: "Основы Российской государственности",
                                                    teacherFullName: "Бредихин Д. А.",
                                                    teacherEndpoint: "/person/bredihin-dmitriy-aleksandrovich",
                                                    lessonType: .Lecture,
                                                    weekDay: .Monday,
                                                    weekType: .Numerator,
                                                    cabinet: "12 корпус ауд.303",
                                                    lessonNumber: 1,
                                                    timeStart: "08:20",
                                                    timeEnd: "09:50"),
                                          
                                          LessonDTO(subject: "Основы Российской государственности",
                                                    teacherFullName: "Бредихин Д. А.",
                                                    lessonType: .Practice,
                                                    weekDay: .Monday,
                                                    weekType: .Denumerator,
                                                    cabinet: "12 корпус ауд.303",
                                                    lessonNumber: 1,
                                                    timeStart: "08:20",
                                                    timeEnd: "09:50")])
                .environmentObject(ViewsManager(viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), schedulePersistenceManager: GroupScheduleCoreDataManager(), groupPersistenceManager: GroupCoreDataManager(), isOpenedFromWidget: false))
                .environmentObject(NetworkMonitor())
                .environmentObject(AppSettings())
                
                ScheduleSubview(lessons: [LessonDTO(subject: "Основы Российской государственности",
                                                    teacherFullName: "Бредихин Д. А.",
                                                    lessonType: .Lecture,
                                                    weekDay: .Monday,
                                                    weekType: .All,
                                                    cabinet: "12 корпус ауд.303",
                                                    lessonNumber: 1,
                                                    timeStart: "08:20",
                                                    timeEnd: "09:50")])
                .environmentObject(ViewsManager(viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), schedulePersistenceManager: GroupScheduleCoreDataManager(), groupPersistenceManager: GroupCoreDataManager(), isOpenedFromWidget: false))
                .environmentObject(NetworkMonitor())
                .environmentObject(AppSettings())
                
                ScheduleSubview(lessons: [LessonDTO(subject: "Основы Российской государственности",
                                                    teacherFullName: "Бредихин Д. А.",
                                                    lessonType: .Practice,
                                                    weekDay: .Monday,
                                                    weekType: .All,
                                                    cabinet: "12 корпус ауд.303",
                                                    lessonNumber: 1,
                                                    timeStart: "08:20",
                                                    timeEnd: "09:50")])
                .environmentObject(NetworkMonitor())
                .environmentObject(ViewsManager(viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), schedulePersistenceManager: GroupScheduleCoreDataManager(), groupPersistenceManager: GroupCoreDataManager(), isOpenedFromWidget: false))
                .environmentObject(AppSettings())
            }
        }
    }
}

//.cornerRadius(20)
//.background(
//    RoundedRectangle(cornerRadius: 20)
//        .fill(Color.white)
//        .padding(.bottom, 0.4)
//        .shadow(color: colorScheme == .light ?
//                        .gray.opacity(0.25) :
//                        .white.opacity(0.5),
//                radius: 5,
//                x: 0,
//                y: 0)
//)
//.padding(.horizontal, 13)
