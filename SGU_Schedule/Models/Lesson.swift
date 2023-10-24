//
//  Class.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation

public struct Lesson: Event {
    
    public var id: UUID
    /// subject
    public var title: String
    var lectorFullName: String
    var lessonType: LessonType
    var weekType: WeekType
    var cabinet: String
    var subgroup: String?
    public var timeStart: Date
    public var timeEnd: Date
    
    init(Subject: String, LectorFullName: String, TimeStart: String, TimeEnd: String, LessonType: LessonType, WeekType: WeekType, Subgroup: String? = nil, Cabinet: String) {
        self.id = UUID()
        self.title = Subject
        self.lectorFullName = LectorFullName
        self.lessonType = LessonType
        self.weekType = WeekType
        self.subgroup = Subgroup
        self.cabinet = Cabinet
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH:mm"
        
        self.timeStart = dateFormatter.date(from: TimeStart)!
        self.timeEnd = dateFormatter.date(from: TimeEnd)!
    }
}
