//
//  SessionEventType.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation

enum SessionEventType : String, Decodable {
    case Test = "Зачет"
    case TestWithMark = "Дифференцированный зачет"
    case Consultation = "Консультация"
    case Exam = "Экзамен"
}
