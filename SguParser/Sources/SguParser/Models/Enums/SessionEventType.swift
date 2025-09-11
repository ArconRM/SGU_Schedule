//
//  SessionEventType.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation

public enum SessionEventType: String, Decodable {
    case test = "Зачет"
    case testWithMark = "Дифференцированный зачет"
    case consultation = "Консультация"
    case exam = "Экзамен"
}
