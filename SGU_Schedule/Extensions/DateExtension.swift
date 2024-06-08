//
//  DateExtension.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation

extension Date {
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
        return [.All, self.currentWeekTypeWithSundayBeingNextWeek].contains(weekType)
    }
    
    func getHours() -> Int {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    ///Divided by colon
    func getHoursAndMinutesString() -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    ///Divided by dot
    func getDayAndMonthString() -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: self)
    }
    
    ///Divided by spaces
    func getDayMonthAndYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func inFuture() -> Bool {
        return Date.now < Calendar.current.date(byAdding: .hour, value: 2, to: self)! && !self.isAroundNow()
    }
    
    func isAroundNow() -> Bool {
        return self.getDayAndMonthString() == Date.now.getDayAndMonthString() && self.getHours() - Date.now.getHours() <= 2
    }
    
    func passed() -> Bool {
        return Date.now > Calendar.current.date(byAdding: .hour, value: 2, to: self)!
    }
    
//    static func getCurrentWeekType() -> WeekType {
//        let calendar = Calendar.current
//        let weekOfYear = calendar.component(.weekOfYear, from: Date())
//        return weekOfYear % 2 == 0 ? .Denumerator : .Numerator
//    }
    
//    static func getTodaysDay() -> Weekdays {
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        let day = dateFormatter.string(from: date)
//        
//        return Weekdays(rawValue: day) ?? .Monday
//    }
    
//    static func getTodaysTime() -> Date {
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        
//        let dateString = dateFormatter.string(from: date)
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        return dateFormatter.date(from: dateString) ?? Date.distantPast
//    }
}
