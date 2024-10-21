//
//  SessionEventDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 27.01.2024.
//

import Foundation

public struct SessionEventDTO: Hashable {
    
    var title: String
    var date: Date
    var sessionEventType: SessionEventType
    var teacherFullName: String
    var cabinet: String
    
    init(title: String, date: Date, sessionEventType: SessionEventType, teacherFullName: String, cabinet: String) {
        self.title = title
        self.date = date
        self.sessionEventType = sessionEventType
        self.teacherFullName = teacherFullName
        self.cabinet = cabinet
    }
    
    /// Date must be in "d MMMM yyyy HH:mm" and Russian localized
    init(title: String, date: String, sessionEventType: SessionEventType, teacherFullName: String, cabinet: String) {
        self.title = title
        self.sessionEventType = sessionEventType
        self.teacherFullName = teacherFullName
        self.cabinet = cabinet
        
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "ru_RU")
//        dateFormatter.dateFormat = "d MMMM yyyy HH:mm"
        dateFormatter.dateFormat = "d MMMM yyyy HH:mm"
        
        self.date = dateFormatter.date(from: date) ?? dateFormatter.date(from: "01 января 2000 00:00")!
    }
    
    public static var mock: SessionEventDTO {
        .init(
            title: "Mock title",
            date: .now,
            sessionEventType: .Exam,
            teacherFullName: "Mock teacher",
            cabinet: "Mock cabinet"
        )
    }
}
