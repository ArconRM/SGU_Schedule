//
//  DateExtension.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation
import SguParser

extension Date {
    static var startOfCurrentWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    static var endOfCurrentWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }

    static func getDayOfCurrentWeek(dayNumber: Int) -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else { return nil }
        return gregorian.date(byAdding: .day, value: dayNumber, to: sunday)
    }

    /// Returns true if date is passed now + some duration in hours
    func passed(duration: Int) -> Bool {
        return Date() > Calendar.current.date(byAdding: .hour, value: duration, to: self)!
    }

    /// Returns todays date with original date's time
    func toTodayDate() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = self.getHours()
        components.minute = self.getMinutes()
        components.second = self.getSeconds()
        return Calendar.current.date(from: components)!
    }
}
