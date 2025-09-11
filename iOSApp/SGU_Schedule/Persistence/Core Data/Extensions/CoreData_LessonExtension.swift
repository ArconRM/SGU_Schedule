//
//  CoreData_LessonExtension.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.10.2023.
//

import Foundation

extension Lesson {
    var lessonType: LessonType {
        get {
            return LessonType(rawValue: self.lessonTypeRawValue ?? "") ?? .lecture
        }
        set {
            self.lessonTypeRawValue = newValue.rawValue
        }
    }

    var weekType: WeekType {
        get {
            return WeekType(rawValue: self.weekTypeRawValue ?? "") ?? .all
        }
        set {
            self.weekTypeRawValue = newValue.rawValue
        }
    }

    var weekDay: Weekdays {
        get {
            return Weekdays(dayNumber: Int(self.weekDayNumber)) ?? .monday
        }
        set {
            self.weekDayNumber = Int16(newValue.number)
        }
    }
}
