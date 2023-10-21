//
//  WeekType.swift
//  SGU_Schedule
//
//  Created by Артемий on 22.10.2023.
//

import Foundation

enum WeekType: String, Decodable {
    case All = ""
    case Numerator = "Числ."
    case Denominator = "Знам."
    
    init?(rawValue: String) {
        if rawValue == "чис." {
            self = .Numerator
        } else if rawValue == "знам." {
            self = .Denominator
        } else {
            self = .All
        }
    }
}
