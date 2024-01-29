//
//  EventSubview.swift
//  Watch_SGU_Schedule Watch App
//
//  Created by Артемий on 18.11.2023.
//

import SwiftUI

struct EventSubview: View {
    
    let event: any ScheduleEventDTO
    
    var body: some View {
        VStack {
            Text(event.timeStart.getHoursAndMinutesString() + " - " +
                 event.timeEnd.getHoursAndMinutesString())
            .font(.system(size: 15, weight: .bold))
            .multilineTextAlignment(.center)
            .padding(.top, 5)
            
            Text(event.title)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
            
            if let lesson = event as? LessonDTO {
                Text(lesson.cabinet)
                    .font(.system(size: 14, weight: .bold))
                    .padding(.top, 5)
            }
        }
    }
}

struct EventSubview_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            EventSubview(event: LessonDTO(subject: "Основы Российской государственности",
                                          lectorFullName: "Бредихин Д. А.",
                                          lessonType: .Lecture,
                                          weekDay: .Monday,
                                          weekType: .Numerator,
                                          cabinet: "12 корпус ауд.303",
                                          lessonNumber: 1,
                                          timeStart: "08:20",
                                          timeEnd: "09:50"))
            EventSubview(event: TimeBreakDTO(timeStart: "08:20", timeEnd: "09:50"))
        }
    }
}
