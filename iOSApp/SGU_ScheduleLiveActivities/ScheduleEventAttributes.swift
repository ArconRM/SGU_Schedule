//
//  ScheduleEventAttributes.swift
//  SGU_ScheduleLiveActivitiesExtension
//
//  Created by Artemiy MIROTVORTSEV on 10.02.2025.
//

import ActivityKit
import Foundation
import SguParser

struct ScheduleEventAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var lessonTitle: String
        var teacherFullName: String
        var lessonType: LessonType
        var cabinet: String
        var timeStart: Date
        var timeEnd: Date
    }
}
