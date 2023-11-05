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
        if rawValue == "лек." || rawValue == "Лекция" {
            self = .Lecture
        } else if rawValue == "пр." || rawValue == "Практика" {
            self = .Practice
        } else {
            return nil
        }
    }
}
