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
        if rawValue == "чис." || rawValue == "Числ." || rawValue == "Ч" {
            self = .Numerator
        } else if rawValue == "знам." || rawValue == "Знам." || rawValue == "З" {
            self = .Denumerator
        } else {
            self = .All
        }
    }
}
