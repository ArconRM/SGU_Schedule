//
//  SessionEventDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 27.01.2024.
//

import Foundation

public struct SessionEventDTO: Hashable {

    /// Subject
    public var title: String
    public var date: Date
    public var sessionEventType: SessionEventType
    public var teacherFullName: String
    public var cabinet: String

    public func getTextDesciption() -> String {
        return """
            \(title) (\(sessionEventType.rawValue))
            \(date.getDayMonthAndYearString()) \(date.getHoursAndMinutesString())
            \(cabinet)
            Преподаватель: \(teacherFullName)
            """
    }

    public init(title: String, date: Date, sessionEventType: SessionEventType, teacherFullName: String, cabinet: String) {
        self.title = title
        self.date = date
        self.sessionEventType = sessionEventType
        self.teacherFullName = teacherFullName
        self.cabinet = cabinet
    }

    /// Date must be in "d MMMM yyyy HH:mm" and Russian localized
    public init(title: String, date: String, sessionEventType: SessionEventType, teacherFullName: String, cabinet: String) {
        self.title = title
        self.sessionEventType = sessionEventType
        self.teacherFullName = teacherFullName
        self.cabinet = cabinet

        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "ru_RU")
//        dateFormatter.dateFormat = "d MMMM yyyy HH:mm"
        dateFormatter.dateFormat = "d MMMM yyyy HH:mm"

        self.date = dateFormatter.date(from: date) ?? dateFormatter.date(from: "01 января 2000 00:00")!
    }

    public static var mock: Self {
        .init(
            title: "Mock title",
            date: .distantFuture,
            sessionEventType: .exam,
            teacherFullName: "Mock teacher",
            cabinet: "Mock cabinet"
        )
    }

    public static var mocks: [Self] {
        var result = [Self]()
        for i in 0..<10 {
            result.append(
                .init(
                    title: "Mock title \(i)",
                    date: .distantFuture,
                    sessionEventType: i % 2 == 0 ? .exam : .consultation,
                    teacherFullName: "Mock teacher",
                    cabinet: "Mock cabinet"
                )
            )
        }
        return result
    }
}
