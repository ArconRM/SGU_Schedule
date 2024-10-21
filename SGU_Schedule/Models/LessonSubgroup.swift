//
//  LessonSubgroup.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 17.10.2024.
//

import Foundation

//TODO: Должно храниться в Lesson
public struct LessonSubgroup: Hashable, Codable {
    
    var teacher: String
    /// То что в Lesson хранится как subgroup
    var number: String
    var isSaved: Bool
    
    var fullNumber: String { "\(number) \(teacher)" }
    var displayNumber : String {
        var result = ""
        for numberPart in fullNumber.split(separator: " ") {
            if numberPart.contains(where: { $0.isNumber }) {
                result = numberPart + " " + result
            } else {
                result += " " + numberPart
            }
        }
        return result
    }
    
    init(teacher: String, number: String, isSaved: Bool) {
        self.teacher = teacher
        self.number = number
        self.isSaved = isSaved
    }
    public static var mock: Self {
        .init(teacher: "Mock Teacher", number: "под. 1", isSaved: false)
    }
}
