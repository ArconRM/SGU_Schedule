//
//  LessonHTMLParser.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public protocol LessonHTMLParser {
//    func getLessonsByDayNumberFromSource(source html: String, dayNumber: Int) throws -> [[LessonDTO]]
    func getScheduleFromSource(source html: String) throws -> [LessonDTO]
    func getGroupScheduleFromSource(source html: String, groupNumber: String, departmentCode: String) throws -> GroupScheduleDTO
}
