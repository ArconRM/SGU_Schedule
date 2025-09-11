//
//  WeekType.swift
//  SGU_Schedule
//
//  Created by Артемий on 22.10.2023.
//

import Foundation

enum WeekType: String, Decodable {
    case all = ""
    case numerator = "Числ."
    case denumerator = "Знам."

    init?(rawValue: String) {
        if rawValue == "чис." || rawValue == "Числ." || rawValue == "Ч" {
            self = .numerator
        } else if rawValue == "знам." || rawValue == "Знам." || rawValue == "З" {
            self = .denumerator
        } else {
            self = .all
        }
    }
}
