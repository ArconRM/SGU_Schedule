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
    
    var body: some View {
        LazyVStack {
            ForEach(lessons, id:\.self) { lesson in
                VStack {
                    HStack {
                        Text("\(lesson.timeStart.getHoursAndMinutesString()) - \(lesson.timeEnd.getHoursAndMinutesString())")
                            .font(.custom("arial", size: 17))
                            .bold()
                        
                        if lesson.weekType != .All {
                            Text("(\(lesson.weekType.rawValue))")
                                .font(.custom("arial", size: 17))
                                .bold()
                        }
                        
                        Spacer()
                        
                        Text(lesson.lessonType.rawValue)
                            .font(.custom("arial", size: 17))
                            .bold()
                            .opacity(0.7)
                    }
                    
                    Text(lesson.title)
                        .multilineTextAlignment(.center)
                        .font(.custom("arial", size: 17))
                        .bold()
                        .padding(.vertical, 19)
                    
                    HStack {
                        if lesson.subgroup != nil {
                            Text("\(lesson.lectorFullName) \n\(lesson.subgroup!)")
                                .font(.custom("arial", size: 17))
                                .italic()
                        } else {
                            Text(lesson.lectorFullName)
                                .font(.custom("arial", size: 17))
                                .italic()
                        }
                        
                        Spacer()
                        
                        Text("\(lesson.cabinet)")
                            .font(.custom("arial", size: 17))
                            .bold()
                    }
                }
                .foregroundColor(colorScheme == .light ? .black : .white)
                .padding(Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) ? 15 : 10)
                .opacity(Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) ? 1 : 0.5)
                .background(Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) ?
                            (lesson.lessonType == .Lecture ? .green.opacity(0.2) : .blue.opacity(0.2))
                            : .gray.opacity(0.1)
                )
//                .cornerRadius(20)
            }
        }
        .background(colorScheme == .light ? Color.white : Color.gray.opacity(0.2))
        .padding(.horizontal, 13)
        .shadow(color: colorScheme == .light ?
                    .gray.opacity(0.3) :
                    .white.opacity(0.2),
                 radius: 5,
                 x: 0,
                 y: 0)
        .cornerRadius(20)
    }
    
    
}

struct ScheduleSubview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.blue.opacity(0.07))
                .ignoresSafeArea()
            VStack {
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
