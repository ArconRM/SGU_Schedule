//
//  Weekdays.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation

public enum Weekdays: String, CaseIterable {
    case Monday = "Пн"
    case Tuesday = "Вт"
    case Wednesday = "Ср"
    case Thursday = "Чт"
    case Friday = "Пт"
    case Saturday = "Сб"
    
    var number: Int {
        switch self {
        case .Monday: return 1
        case .Tuesday: return 2
        case .Wednesday: return 3
        case .Thursday: return 4
        case .Friday: return 5
        case .Saturday: return 6
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        case "Monday": self = .Monday
        case "Tuesday": self = .Tuesday
        case "Wednesday": self = .Wednesday
        case "Thursday": self = .Thursday
        case "Friday": self = .Friday
        case "Saturday": self = .Saturday
        default:
            return nil
        }
    }
}
