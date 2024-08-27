//
//  LessonType.swift
//  SGU_Schedule
//
//  Created by Артемий on 22.10.2023.
//

import Foundation

enum LessonType: String, Decodable {
    case Lecture = "Лекция"
    case Practice = "Практика"
    
    init?(rawValue: String) {
        if rawValue.lowercased() == "лек." || rawValue.lowercased() == "лекция" {
            self = .Lecture
        } else if rawValue.lowercased() == "пр." || rawValue.lowercased() == "практика" {
            self = .Practice
        } else {
            return nil
        }
    }
}
