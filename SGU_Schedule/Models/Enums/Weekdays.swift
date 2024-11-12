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
    case Sunday = "Вс"
    
    var number: Int {
        switch self {
        case .Monday: return 1
        case .Tuesday: return 2
        case .Wednesday: return 3
        case .Thursday: return 4
        case .Friday: return 5
        case .Saturday: return 6
        case .Sunday: return 7
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "monday", "понедельник": self = .Monday
        case "tuesday", "вторник": self = .Tuesday
        case "wednesday", "среда": self = .Wednesday
        case "thursday", "четверг": self = .Thursday
        case "friday", "пятница": self = .Friday
        case "saturday", "суббота": self = .Saturday
        case "sunday", "воскресенье": self = .Sunday
        default:
            return nil
        }
    }
    
    public init?(dayNumber: Int) {
        switch dayNumber {
        case 1: self = .Monday
        case 2: self = .Tuesday
        case 3: self = .Wednesday
        case 4: self = .Thursday
        case 5: self = .Friday
        case 6: self = .Saturday
        case 7: self = .Sunday
        default:
            return nil
        }
    }
}
