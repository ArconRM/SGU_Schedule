//
//  LessonDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation

public struct LessonDTO: Identifiable, Equatable, ScheduleEventDTO {
    
    public var id: UUID
    /// subject
    public var title: String
    var teacherFullName: String
    var teacherEndpoint: String?
    var lessonType: LessonType
    var weekDay: Weekdays
    var weekType: WeekType
    var cabinet: String
    var subgroup: String?
    var lessonNumber: Int
    public var timeStart: Date
    public var timeEnd: Date
    
    
    /// TimeStart and TimeEnd must be in "HH:mm" format
    init(
        subject: String,
        teacherFullName: String,
        teacherEndpoint: String? = nil,
        lessonType: LessonType,
        weekDay: Weekdays,
        weekType: WeekType,
        cabinet: String,
        subgroup: String? = nil,
        lessonNumber: Int,
        timeStart: String,
        timeEnd: String
    ) {
        self.id = UUID()
        self.title = subject
        self.teacherFullName = teacherFullName
        self.teacherEndpoint = teacherEndpoint
        self.lessonType = lessonType
        self.weekDay = weekDay
        self.weekType = weekType
        self.cabinet = cabinet
        self.subgroup = subgroup
        self.lessonNumber = lessonNumber
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        self.timeStart = dateFormatter.date(from: timeStart) ?? dateFormatter.date(from: "00:00")!
        self.timeEnd = dateFormatter.date(from: timeEnd) ?? dateFormatter.date(from: "00:00")!
    }
    
    init(
        subject: String,
        teacherFullName: String,
        teacherEndpoint: String? = nil,
        lessonType: LessonType,
        weekDay: Weekdays,
        weekType: WeekType,
        cabinet: String,
        subgroup: String? = nil,
        lessonNumber: Int,
        timeStart: Date,
        timeEnd: Date
    ) {
        self.id = UUID()
        self.title = subject
        self.teacherFullName = teacherFullName
        self.teacherEndpoint = teacherEndpoint
        self.lessonType = lessonType
        self.weekDay = weekDay
        self.weekType = weekType
        self.cabinet = cabinet
        self.subgroup = subgroup
        self.lessonNumber = lessonNumber
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }
    
    /// All but id, because it needs to compare the one gotten from site and the one which is already in store
    public static func == (lhs: LessonDTO, rhs: LessonDTO) -> Bool {
        return (lhs.title == rhs.title &&
                lhs.teacherFullName == rhs.teacherFullName &&
                lhs.teacherEndpoint == rhs.teacherEndpoint &&
                lhs.lessonType == rhs.lessonType &&
                lhs.weekDay == rhs.weekDay &&
                lhs.weekType == rhs.weekType &&
                lhs.cabinet == rhs.cabinet &&
                lhs.subgroup == rhs.subgroup &&
                lhs.lessonNumber == rhs.lessonNumber &&
                lhs.timeStart == rhs.timeStart &&
                lhs.timeEnd == rhs.timeEnd)
    }
}
