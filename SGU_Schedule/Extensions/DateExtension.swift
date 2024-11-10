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
        get {
            let calendar = Calendar.current
            let weekOfYear = calendar.component(.weekOfYear, from: Date())
            return (weekOfYear) % 2 == 0 ? .Denumerator : .Numerator
        }
    }
    
    /// If current weekday is Sunday, it will return weekType of next week
    static var currentWeekTypeWithSundayBeingNextWeek: WeekType {
        get {
            let calendar = Calendar.current
            let weekOfYear = calendar.component(.weekOfYear, from: Date())
            let isSunday = calendar.component(.weekday, from: Date()) == 1
            return (weekOfYear + (isSunday ? 1 : 0)) % 2 == 0 ? .Denumerator : .Numerator
        }
    }
    
    static var currentWeekDay: Weekdays {
        get {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let day = dateFormatter.string(from: date)
            
            return Weekdays(rawValue: day) ?? .Monday
        }
    }
    
    /// If current hour is more than or equals 22, returns next day
    static var currentWeekDayWithEveningBeingNextDay: Weekdays {
        get {
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
            
            return Weekdays(rawValue: day) ?? .Monday
        }
    }
    
    static var currentWeekDayWithoutSunday: Weekdays {
        get {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let day = dateFormatter.string(from: date)
            
            return(Weekdays(rawValue: day) == .Sunday) ? .Monday : (Weekdays(rawValue: day) ?? .Monday)
        }
    }
    
    /// If current hour is more than or equals 22, returns next day (ignoring Sunday)
    static var currentWeekDayWithoutSundayAndWithEveningBeingNextDay: Weekdays {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let currentTime = Date.currentHoursAndMinutes
            
            var date = Date()
            if currentTime.getHours() >= 22 {
                date.addTimeInterval(10800)
            }
            
            let day = dateFormatter.string(from: date)
            
            return (Weekdays(rawValue: day) == .Sunday) ? .Monday : (Weekdays(rawValue: day) ?? .Monday)
        }
    }
    
    static var currentHoursAndMinutes: Date {
        get {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            let dateString = dateFormatter.string(from: date)
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            return dateFormatter.date(from: dateString) ?? Date.distantPast
        }
    }
    
    /// Returns true if weekType equals .All or current weekType
    static func checkIfWeekTypeIsAllOrCurrent(_ weekType: WeekType) -> Bool {
        return [.All, self.currentWeekType].contains(weekType)
    }
    
    /// Returns true if weekType equals .All or current weekType
    static func checkIfWeekTypeIsAllOrCurrentWithSundayBeingNextWeek(_ weekType: WeekType) -> Bool {
        return [.All, self.currentWeekTypeWithSundayBeingNextWeek].contains(weekType)
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
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    func getMinutes() -> Int {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "mm"
        return Int(dateFormatter.string(from: self)) ?? 0
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
        dateFormatter.dateFormat = "dd\(divider)MM"
        return dateFormatter.string(from: self)
    }
    
    func getDayAndMonthWordString(divider: String = " ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd\(divider)MMMM"
        return dateFormatter.string(from: self)
    }
    
    func getDayMonthAndYearString(divider: String = " ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "d\(divider)MMMM\(divider)yyyy"
        return dateFormatter.string(from: self)
    }
    
    func inFuture() -> Bool {
        return Date() < Calendar.current.date(byAdding: .hour, value: 2, to: self)! && !self.isAroundNow()
    }
    
    func isAroundNow() -> Bool {
        return self.getDayAndMonthString() == Date().getDayAndMonthString() && Date().getHours() - self.getHours() < 2
    }
    
    func passed() -> Bool {
        return Date() > Calendar.current.date(byAdding: .hour, value: 2, to: self)!
    }
}
