//
//  Weekdays.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation

public enum Weekdays: String, CaseIterable {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Вс"

    public var number: Int {
        switch self {
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        case .sunday: return 7
        }
    }

    public init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "monday", "понедельник": self = .monday
        case "tuesday", "вторник": self = .tuesday
        case "wednesday", "среда": self = .wednesday
        case "thursday", "четверг": self = .thursday
        case "friday", "пятница": self = .friday
        case "saturday", "суббота": self = .saturday
        case "sunday", "воскресенье": self = .sunday
        default:
            return nil
        }
    }

    public init?(dayNumber: Int) {
        switch dayNumber {
        case 1: self = .monday
        case 2: self = .tuesday
        case 3: self = .wednesday
        case 4: self = .thursday
        case 5: self = .friday
        case 6: self = .saturday
        case 7: self = .sunday
        default:
            return nil
        }
    }
}
