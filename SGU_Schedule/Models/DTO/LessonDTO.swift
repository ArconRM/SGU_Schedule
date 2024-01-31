//
//  LessonDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation

public struct LessonDTO: ScheduleEventDTO {
    
//    public var id: UUID
    /// subject
    public var title: String
    var lectorFullName: String
    var lessonType: LessonType
    var weekDay: Weekdays
    var weekType: WeekType
    var cabinet: String
    var subgroup: String?
    var lessonNumber: Int
    public var timeStart: Date
    public var timeEnd: Date
    
    
    /// TimeStart and TimeEnd must be in "HH:mm" format
    init(subject: String, lectorFullName: String, lessonType: LessonType, weekDay: Weekdays, weekType: WeekType, cabinet: String, subgroup: String? = nil, lessonNumber: Int, timeStart: String, timeEnd: String) {
//        self.id = UUID()
        self.title = subject
        self.lectorFullName = lectorFullName
        self.lessonType = lessonType
        self.weekDay = weekDay
        self.weekType = weekType
        self.cabinet = cabinet
        self.subgroup = subgroup
        self.lessonNumber = lessonNumber
        
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH:mm"
        
        self.timeStart = dateFormatter.date(from: timeStart) ?? dateFormatter.date(from: "00:00")!
        self.timeEnd = dateFormatter.date(from: timeEnd) ?? dateFormatter.date(from: "00:00")!
    }
    
    init(subject: String, lectorFullName: String, lessonType: LessonType, weekDay: Weekdays, weekType: WeekType, cabinet: String, subgroup: String? = nil, lessonNumber: Int, timeStart: Date, timeEnd: Date) {
//        self.id = UUID()
        self.title = subject
        self.lectorFullName = lectorFullName
        self.lessonType = lessonType
        self.weekDay = weekDay
        self.weekType = weekType
        self.cabinet = cabinet
        self.subgroup = subgroup
        self.lessonNumber = lessonNumber
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }
}
