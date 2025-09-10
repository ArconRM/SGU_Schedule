//
//  DateExtension.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation

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

    /// If current weekday is Sunday, it will return weekType of next week
    static var currentWeekType: WeekType {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date())
        return (weekOfYear) % 2 == 1 ? .denumerator : .numerator
    }

    /// If current weekday is Sunday, it will return weekType of next week
    static var currentWeekTypeWithSundayBeingNextWeek: WeekType {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date())
        let isSunday = calendar.component(.weekday, from: Date()) == 1
        return (weekOfYear + (isSunday ? 1 : 0)) % 2 == 1 ? .denumerator : .numerator
    }

    static var currentWeekday: Weekdays {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: date)

        return Weekdays(rawValue: day) ?? .monday
    }

    var weekday: Weekdays {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: self)

        return Weekdays(rawValue: day) ?? .monday
    }

    /// If current hour is more than or equals 22, returns next day
    static var currentWeekDayWithEveningBeingNextDay: Weekdays {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"

        var currentDate = Date()
        let currentTime = Date.currentHoursAndMinutes
        var dateComponent = DateComponents()
        dateComponent.day = 1

        if currentTime.getHours() >= 22 {
            currentDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
        }

        let day = dateFormatter.string(from: currentDate)

        return Weekdays(rawValue: day) ?? .monday
    }

    static var currentWeekDayWithoutSunday: Weekdays {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: date)

        return(Weekdays(rawValue: day) == .sunday) ? .monday : (Weekdays(rawValue: day) ?? .monday)
    }

    /// If current hour is more than or equals 22, returns next day (ignoring Sunday)
    static var currentWeekDayWithoutSundayAndWithEveningBeingNextDay: Weekdays {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let currentTime = Date.currentHoursAndMinutes

        var date = Date()
        if currentTime.getHours() >= 22 {
            date.addTimeInterval(10800)
        }

        let day = dateFormatter.string(from: date)

        return (Weekdays(rawValue: day) == .sunday) ? .monday : (Weekdays(rawValue: day) ?? .monday)
    }

    static var currentHoursAndMinutes: Date {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let dateString = dateFormatter.string(from: date)
        //            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString) ?? Date.distantPast
    }

    /// Returns true if weekType equals .All or current weekType
    static func checkIfWeekTypeIsAllOrCurrent(_ weekType: WeekType) -> Bool {
        return [.all, self.currentWeekType].contains(weekType)
    }

    /// Returns true if weekType equals .All or current weekType
    static func checkIfWeekTypeIsAllOrCurrentWithSundayBeingNextWeek(_ weekType: WeekType) -> Bool {
        return [.all, self.currentWeekTypeWithSundayBeingNextWeek].contains(weekType)
    }

    /// Returns true if dateMiddle is more than dateStart or equals it and if dateMiddle is less than dateEnd or equals it
    static func checkIfTimeIsBetweenTwoTimes(dateStart: Date, dateMiddle: Date, dateEnd: Date, strictInequality: Bool = false) -> Bool {
        return compareDatesByTime(date1: dateMiddle, date2: dateStart, strictInequality: strictInequality)
        && compareDatesByTime(date1: dateEnd, date2: dateMiddle, strictInequality: strictInequality)
    }

    /// Returns true if date1 is bigger than date2 or equals it.
    static func compareDatesByTime(date1: Date, date2: Date, strictInequality: Bool) -> Bool {
        let calendar = Calendar.current
        var dateToCompare1 = Date.init(timeIntervalSinceReferenceDate: 0)
        var dateToCompare2 = Date.init(timeIntervalSinceReferenceDate: 0)

        let date1Components = calendar.dateComponents([.hour, .minute, .second], from: date1)
        let date2Components = calendar.dateComponents([.hour, .minute, .second], from: date2)

        dateToCompare1 = calendar.date(byAdding: date1Components, to: dateToCompare1) ?? Date.now
        dateToCompare2 = calendar.date(byAdding: date2Components, to: dateToCompare2) ?? Date.now

        return (strictInequality ? dateToCompare1 > dateToCompare2 : dateToCompare1 >= dateToCompare2)
    }

    func getHours() -> Int {
        return Calendar.current.component(.hour, from: self)
    }

    func getMinutes() -> Int {
        return Calendar.current.component(.minute, from: self)
    }

    func getSeconds() -> Int {
        return Calendar.current.component(.second, from: self)
    }

    func getHoursAndMinutesString(divider: String = ":") -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH\(divider)mm"
        return dateFormatter.string(from: self)
    }

    func getDayAndMonthString(divider: String = ".") -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "d\(divider)MM"
        return dateFormatter.string(from: self)
    }

    func getDayAndMonthWordString(divider: String = " ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd\(divider)MMM"
        return dateFormatter.string(from: self)
    }

    func getDayMonthAndYearString(divider: String = " ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "d\(divider)MMMM\(divider)yyyy"
        return dateFormatter.string(from: self)
    }

    func isInFuture() -> Bool {
        return Date() < self
    }

    func isInFuture(days: Int) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        let components2 = calendar.dateComponents([.year, .month, .day], from: Calendar.current.date(byAdding: .day, value: days, to: Date())!)

        return components1 == components2
    }

    func isToday() -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        let components2 = calendar.dateComponents([.year, .month, .day], from: Date())

        return components1 == components2
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
