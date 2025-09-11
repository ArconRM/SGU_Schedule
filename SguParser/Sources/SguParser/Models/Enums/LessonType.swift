//
//  LessonType.swift
//  SGU_Schedule
//
//  Created by Артемий on 22.10.2023.
//

import Foundation

public enum LessonType: String, Codable {
    case lecture = "Лекция"
    case practice = "Практика"

    public init?(rawValue: String) {
        if rawValue.lowercased() == "лек." || rawValue.lowercased() == "лекция" {
            self = .lecture
        } else if rawValue.lowercased() == "пр." || rawValue.lowercased() == "практика" {
            self = .practice
        } else {
            return nil
        }
    }
}
