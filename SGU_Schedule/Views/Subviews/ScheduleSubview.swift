//
//  ScheduleSubview.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI

struct ScheduleSubview: View {
    @Environment(\.colorScheme) var colorScheme
    
    let lessons: [LessonDTO]
    
    @State var areMultipleLessonsCollapsed: Bool = true
    
    var body: some View {
        VStack {
            if lessons.count == 1 {
                makeSingleLessonView(lesson: lessons.first!)
            } else if lessons.count >= 1 {
                if areMultipleLessonsCollapsed {
                    makeMultipleLessonsView(firstLesson: lessons.first!)
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.5)) {
                                areMultipleLessonsCollapsed.toggle()
                            }
                        }
                } else {
                    makeMultipleLessonsView(lessons: lessons)
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
                    .font(.system(size: 17))
                    .bold()
                    .opacity(0.7)
            }
            
            Text(lesson.title)
                .multilineTextAlignment(.center)
                .font(.system(size: 17, weight: .bold))
                .padding(.vertical, 19)
            
            HStack {
                if lesson.subgroup != nil && lesson.subgroup != "" {
                    Text("\(lesson.lectorFullName) \n\(lesson.subgroup!)")
                        .font(.system(size: 17))
                        .italic()
                } else {
                    Text(lesson.lectorFullName)
                        .font(.system(size: 17))
                        .italic()
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
        .background(Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) ?
                    (lesson.lessonType == .Lecture ? .green.opacity(0.2) : .blue.opacity(0.2))
                    : .gray.opacity(0.1)
        )
    }
    
    private func makeMultipleLessonsView(lessons: [LessonDTO]) -> some View {
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
                        .font(.system(size: 17))
                        .bold()
                        .opacity(0.7)
                }
                
                Text(lesson.title)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 17, weight: .bold))
                    .padding(.vertical, 19)
                
                HStack {
                    if lesson.subgroup != nil && lesson.subgroup != "" {
                        Text("\(lesson.lectorFullName) \n\(lesson.subgroup!)")
                            .font(.system(size: 17))
                            .italic()
                    } else {
                        Text(lesson.lectorFullName)
                            .font(.system(size: 17))
                            .italic()
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
            .background(Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) ?
                        (lesson.lessonType == .Lecture ? .green.opacity(0.2) : .blue.opacity(0.2))
                        : .gray.opacity(0.1)
            )
        }
    }
    
    private func makeMultipleLessonsView(firstLesson lesson: LessonDTO) -> some View {
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
                    .font(.system(size: 17))
                    .bold()
                    .opacity(0.7)
            }
            
            Text(lesson.title)
                .multilineTextAlignment(.center)
                .font(.system(size: 17, weight: .bold))
                .padding(.vertical, 19)
            
            HStack {
                if lesson.subgroup == nil || lesson.subgroup == "" {
                    Text(lesson.lectorFullName)
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
        .background(Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) ?
                    (lesson.lessonType == .Lecture ? .green.opacity(0.2) : .blue.opacity(0.2))
                    : .gray.opacity(0.1)
        )
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
                                                    lectorFullName: "Бредихин Д. А.",
                                                    lessonType: .Lecture,
                                                    weekDay: .Monday,
                                                    weekType: .Numerator,
                                                    cabinet: "12 корпус ауд.303",
                                                    lessonNumber: 1,
                                                    timeStart: "08:20",
                                                    timeEnd: "09:50"),
                                          
                                          LessonDTO(subject: "Основы Российской государственности",
                                                    lectorFullName: "Бредихин Д. А.",
                                                    lessonType: .Practice,
                                                    weekDay: .Monday,
                                                    weekType: .Denumerator,
                                                    cabinet: "12 корпус ауд.303",
                                                    lessonNumber: 1,
                                                    timeStart: "08:20",
                                                    timeEnd: "09:50")])
                
                ScheduleSubview(lessons: [LessonDTO(subject: "Основы Российской государственности",
                                                    lectorFullName: "Бредихин Д. А.",
                                                    lessonType: .Lecture,
                                                    weekDay: .Monday,
                                                    weekType: .All,
                                                    cabinet: "12 корпус ауд.303",
                                                    lessonNumber: 1,
                                                    timeStart: "08:20",
                                                    timeEnd: "09:50")])
                
                ScheduleSubview(lessons: [LessonDTO(subject: "Основы Российской государственности",
                                                    lectorFullName: "Бредихин Д. А.",
                                                    lessonType: .Practice,
                                                    weekDay: .Monday,
                                                    weekType: .All,
                                                    cabinet: "12 корпус ауд.303",
                                                    lessonNumber: 1,
                                                    timeStart: "08:20",
                                                    timeEnd: "09:50")])
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
