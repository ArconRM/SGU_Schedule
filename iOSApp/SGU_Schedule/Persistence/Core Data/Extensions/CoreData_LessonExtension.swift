//
//  CoreData_LessonExtension.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.10.2023.
//

import Foundation
import SguParser

extension Lesson {
    public var lessonType: LessonType {
        get {
            return LessonType(rawValue: self.lessonTypeRawValue ?? "") ?? .lecture
        }
        set {
            self.lessonTypeRawValue = newValue.rawValue
        }
    }

    public var weekType: WeekType {
        get {
            return WeekType(rawValue: self.weekTypeRawValue ?? "") ?? .all
        }
        set {
            self.weekTypeRawValue = newValue.rawValue
        }
    }

    public var weekDay: Weekdays {
        get {
            return Weekdays(dayNumber: Int(self.weekDayNumber)) ?? .monday
        }
        set {
            self.weekDayNumber = Int16(newValue.number)
        }
    }
}
