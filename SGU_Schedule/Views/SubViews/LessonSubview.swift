//
//  LessonSubview.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI

struct LessonSubview: View {
    
    let lessons: [Lesson]
    
    var body: some View {
        VStack{
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
                            .foregroundColor(.black)
                            .bold()
                            .opacity(0.7)
                    }
                    
                    Text(lesson.subject)
                        .multilineTextAlignment(.center)
                        .font(.custom("arial", size: 17))
                        .bold()
                        .padding(.vertical, 12)
                    
                    HStack {
                        if lesson.subgroup != "" {
                            Text("\(lesson.lectorFullName) \n\(lesson.subgroup)")
                                .font(.custom("arial", size: 17))
                                .bold()
                        } else {
                            Text(lesson.lectorFullName)
                                .font(.custom("arial", size: 17))
                                .bold()
                        }
                        
                        Spacer()
                        
                        Text("\(lesson.cabinet)")
                            .font(.custom("arial", size: 17))
                            .foregroundColor(.black)
                            .bold()
                            .opacity(0.7)
                    }
                }
                if lesson != lessons.last {
                    Divider()
                }
            }
        }
        .padding(20)
        .background(.white.opacity(0.9))
    }
}

struct LessonSubview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            LessonSubview(lessons: [Lesson(Subject: "Основы Российской государственности", LectorFullName: "Бредихин Д. А.", TimeStart: "08:20", TimeEnd: "09:50", LessonType: LessonType.Lecture, WeekType: .Numerator, Subgroup: nil, Cabinet: "12 корпус ауд.303"), Lesson(Subject: "Основы Российской государственности", LectorFullName: "Бредихин Д. А.", TimeStart: "08:20", TimeEnd: "09:50", LessonType: LessonType.Practice, WeekType: .All, Subgroup: "под. 3", Cabinet: "12 корпус ауд.303")])
        }
    }
}
