//
//  LessonHTMLParser.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public protocol LessonHTMLParser {
    func getLessonsByDayNumberFromSource(source html: String, dayNumber: Int) throws -> [[Lesson]]
    func getLessonsOnCurrentWeekFromSource(source html: String) throws -> [[[Lesson]]]
}
