//
//  CoreData_LessonExtension.swift
//  Watch_SGU_Schedule Watch App
//
//  Created by Артемий on 18.11.2023.
//

import Foundation

extension Lesson {
    
    /// Note: sets Lecture if value is null or incorrect
    var lessonType: LessonType {
            get {
                return LessonType(rawValue: self.lessonTypeRawValue ?? "") ?? .Lecture
            }
            set {
                self.lessonTypeRawValue = newValue.rawValue
            }
        }
    
    var weekType: WeekType {
        get {
            return WeekType(rawValue: self.weekTypeRawValue ?? "") ?? .All
        }
        set {
            self.weekTypeRawValue = newValue.rawValue
        }
    }
    
    var weekDay: Weekdays {
        get {
            return Weekdays(dayNumber: Int(self.weekDayNumber)) ?? .Monday
        }
        set {
            self.weekDayNumber = Int16(newValue.number)
        }
    }
}
