//
//  CoreData_LessonExtension.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.10.2023.
//

import Foundation
//import CoreData

extension Lesson {
    
    /// Sets Lecture if value is null or incorrect
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
}
