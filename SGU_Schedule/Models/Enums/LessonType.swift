//
//  LessonType.swift
//  SGU_Schedule
//
//  Created by Артемий on 22.10.2023.
//

import Foundation

enum LessonType: String, Decodable {
    case lecture = "Лекция"
    case practice = "Практика"

    init?(rawValue: String) {
        if rawValue.lowercased() == "лек." || rawValue.lowercased() == "лекция" {
            self = .lecture
        } else if rawValue.lowercased() == "пр." || rawValue.lowercased() == "практика" {
            self = .practice
        } else {
            return nil
        }
    }
}
