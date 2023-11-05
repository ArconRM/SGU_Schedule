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
    case Denumerator = "Знам."
    
    init?(rawValue: String) {
        if rawValue == "чис." || rawValue == "Числ." {
            self = .Numerator
        } else if rawValue == "знам." || rawValue == "Знам." {
            self = .Denumerator
        } else {
            self = .All
        }
    }
}
