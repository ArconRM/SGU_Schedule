//
//  WeekType.swift
//  SGU_Schedule
//
//  Created by Артемий on 22.10.2023.
//

import Foundation

public enum WeekType: String, Codable {
    case all = ""
    case numerator = "Числ."
    case denumerator = "Знам."

    public init?(rawValue: String) {
        if rawValue == "чис." || rawValue == "Числ." || rawValue == "Ч" {
            self = .numerator
        } else if rawValue == "знам." || rawValue == "Знам." || rawValue == "З" {
            self = .denumerator
        } else {
            self = .all
        }
    }
}
