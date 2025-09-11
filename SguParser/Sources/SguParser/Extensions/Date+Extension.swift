//
//  DateExtension.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation

extension Date {
    
    public func getHours() -> Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    public func getMinutes() -> Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    public func getSeconds() -> Int {
        return Calendar.current.component(.second, from: self)
    }
    
    public func getHoursAndMinutesString(divider: String = ":") -> String {
        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH\(divider)mm"
        return dateFormatter.string(from: self)
    }
    
    public func getDayAndMonthString(divider: String = ".") -> String {
        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "d\(divider)MM"
        return dateFormatter.string(from: self)
    }
    
    public func getDayAndMonthWordString(divider: String = " ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd\(divider)MMM"
        return dateFormatter.string(from: self)
    }
    
    public func getDayMonthAndYearString(divider: String = " ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "d\(divider)MMMM\(divider)yyyy"
        return dateFormatter.string(from: self)
    }
    
    /// If current weekday is Sunday, it will return weekType of next week
    public static var currentWeekType: WeekType {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date())
        return (weekOfYear) % 2 == 1 ? .denumerator : .numerator
    }
    
    /// If current weekday is Sunday, it will return weekType of next week
    public static var currentWeekTypeWithSundayBeingNextWeek: WeekType {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date())
        let isSunday = calendar.component(.weekday, from: Date()) == 1
        return (weekOfYear + (isSunday ? 1 : 0)) % 2 == 1 ? .denumerator : .numerator
    }
    
    public static var currentWeekday: Weekdays {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: date)
        
        return Weekdays(rawValue: day) ?? .monday
    }
    
    public var weekday: Weekdays {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: self)
        
        return Weekdays(rawValue: day) ?? .monday
    }
    
    /// If current hour is more than or equals 22, returns next day
    public static var currentWeekDayWithEveningBeingNextDay: Weekdays {
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
    public static var currentWeekDayWithoutSundayAndWithEveningBeingNextDay: Weekdays {
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
    
    public static var currentHoursAndMinutes: Date {
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
    public static func compareDatesByTime(date1: Date, date2: Date, strictInequality: Bool) -> Bool {
        let calendar = Calendar.current
        var dateToCompare1 = Date.init(timeIntervalSinceReferenceDate: 0)
        var dateToCompare2 = Date.init(timeIntervalSinceReferenceDate: 0)
        
        let date1Components = calendar.dateComponents([.hour, .minute, .second], from: date1)
        let date2Components = calendar.dateComponents([.hour, .minute, .second], from: date2)
        
        dateToCompare1 = calendar.date(byAdding: date1Components, to: dateToCompare1) ?? Date()
        dateToCompare2 = calendar.date(byAdding: date2Components, to: dateToCompare2) ?? Date()
        
        return (strictInequality ? dateToCompare1 > dateToCompare2 : dateToCompare1 >= dateToCompare2)
    }
    
    public func isInFuture() -> Bool {
        return Date() < self
    }
    
    public func isInFuture(days: Int) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        let components2 = calendar.dateComponents([.year, .month, .day], from: Calendar.current.date(byAdding: .day, value: days, to: Date())!)
        
        return components1 == components2
    }
    
    public func isToday() -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        let components2 = calendar.dateComponents([.year, .month, .day], from: Date())
        
        return components1 == components2
    }
}
