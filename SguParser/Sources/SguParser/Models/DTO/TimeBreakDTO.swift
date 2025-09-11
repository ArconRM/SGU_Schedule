//
//  TimeBreakDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 23.10.2023.
//

import Foundation

public struct TimeBreakDTO: ScheduleEvent {

    public var title: String
    public var weekDay: Weekdays
    public var lessonNumber: Int
    public var timeStart: Date
    public var timeEnd: Date

    init(weekDay: Weekdays, lessonNumber: Int, timeStart: Date, timeEnd: Date, isWindow: Bool) {
        self.title = isWindow ? "Окно" : "Перемена"
        self.weekDay = weekDay
        self.lessonNumber = lessonNumber
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }

    /// TimeStart and TimeEnd must be in "HH:mm" format
    init(weekDay: Weekdays, lessonNumber: Int, timeStart: String, timeEnd: String, isWindow: Bool) {
        self.title = isWindow ? "Окно" : "Перемена"
        self.weekDay = weekDay
        self.lessonNumber = lessonNumber

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short

        self.timeStart = dateFormatter.date(from: timeStart) ?? dateFormatter.date(from: "00:00")!
        self.timeEnd = dateFormatter.date(from: timeEnd) ?? dateFormatter.date(from: "00:00")!
    }
}
