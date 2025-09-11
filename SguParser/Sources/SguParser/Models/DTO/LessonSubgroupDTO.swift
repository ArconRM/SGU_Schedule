//
//  LessonSubgroupDTO.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 17.10.2024.
//

import Foundation

// TODO: Должно храниться в Lesson
public struct LessonSubgroupDTO: Hashable, Codable {

    public var teacher: String
    /// То что в Lesson хранится как subgroup
    public var number: String
    public var isSaved: Bool

    public var fullNumber: String { "\(number) \(teacher)" }
    public var displayNumber: String {
        var result = ""
        for numberPart in fullNumber.split(separator: " ") {
            if numberPart.contains(where: { $0.isNumber }) {
                result = numberPart + " " + result
            } else {
                result += " " + numberPart
            }
        }
        return result.trimmingCharacters(in: .whitespaces)
    }

    public init(teacher: String, number: String, isSaved: Bool) {
        self.teacher = teacher
        self.number = number
        self.isSaved = isSaved
    }

    public static var mock: Self {
        .init(teacher: "Пример ФИО", number: "под. 1", isSaved: false)
    }
}
