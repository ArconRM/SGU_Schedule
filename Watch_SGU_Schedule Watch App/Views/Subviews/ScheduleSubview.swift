//
//  ScheduleSubview.swift
//  Watch_SGU_Schedule Watch App
//
//  Created by Артемий on 18.11.2023.
//

import SwiftUI

struct ScheduleSubview: View {
    let lessons: [LessonDTO]
    
    var body: some View {
        ScrollView {
            ForEach(lessons, id:\.self) { lesson in
                VStack {
                    Text("\(lesson.timeStart.getHoursAndMinutesString()) - \(lesson.timeEnd.getHoursAndMinutesString())")
                        .font(.system(size: 12))
                        .bold()
                    
                    if lesson.weekType != .All {
                        Text("\(lesson.weekType.rawValue)")
                            .font(.system(size: 10))
                            .bold()
                    }
                    
                    Text(lesson.title)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 13, weight: .bold))
                        .padding(.vertical, 5)
                    
                    HStack {
                        if lesson.subgroup != nil {
                            Text("\(lesson.lectorFullName) \n\(lesson.subgroup!)")
                                .font(.system(size: 10))
                                .italic()
                        } else {
                            Text(lesson.lectorFullName)
                                .font(.system(size: 12))
                                .italic()
                        }
                        
                        Spacer()
                        
                        Text("\(lesson.cabinet)")
                            .font(.system(size: 10))
                            .bold()
                    }
                }
                .foregroundColor(.white)
                .padding(5)
                .opacity(Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) ? 1 : 0.5)
                .cornerRadius(10)
                .background(Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) ?
                            (lesson.lessonType == .Lecture ? .green.opacity(0.2) : .blue.opacity(0.2))
                            : .gray.opacity(0.1)
                )
            }.background(.blue.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 3)
                .shadow(color: .white.opacity(0.2),
                        radius: 5,
                        x: 0,
                        y: 0)
        }
        
    }
}

struct ScheduleSubview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
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
                                                    weekType: .All,
                                                    cabinet: "12 корпус ауд.303",
                                                    lessonNumber: 1,
                                                    timeStart: "08:20",
                                                    timeEnd: "09:50"),
                                          LessonDTO(subject: "Основы Российской государственности",
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
