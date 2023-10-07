//
//  Class.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation

enum LessonType: String, Decodable {
    case Lecture = "лек."
    case Practice = "пр."
    
    init?(rawValue: String) {
        if rawValue == "лек." {
            self = .Lecture
        } else if rawValue == "пр." {
            self = .Practice
        } else {
            return nil
        }
    }
}

enum WeekType: String, Decodable {
    case All = ""
    case Numerator = "Числ."
    case Denominator = "Знам."
    
    init?(rawValue: String) {
        if rawValue == "чис." {
            self = .Numerator
        } else if rawValue == "знам." {
            self = .Denominator
        } else {
            self = .All
        }
    }
}



public struct Lesson: Hashable, Identifiable, Decodable {
    
    public var id: UUID
    var subject: String
    var lectorFullName: String
    var lessonType: LessonType
    var weekType: WeekType
    var cabinet: String
    var subgroup: String
    var timeStart: Date
    var timeEnd: Date
    
    ///Subgroup can be null
    init(Subject: String, LectorFullName: String, TimeStart: String, TimeEnd: String, LessonType: LessonType, WeekType: WeekType, Subgroup: String?, Cabinet: String) {
        self.id = UUID()
        self.subject = Subject
        self.lectorFullName = LectorFullName
        self.lessonType = LessonType
        self.weekType = WeekType
        self.subgroup = Subgroup ?? ""
        self.cabinet = Cabinet
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH:mm"
        
        self.timeStart = dateFormatter.date(from: TimeStart)!
        self.timeEnd = dateFormatter.date(from: TimeEnd)!
    }
}
