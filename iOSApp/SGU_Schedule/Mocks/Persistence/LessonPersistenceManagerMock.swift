//
//  LessonPersistenceManagerMock.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation

final class LessonPersistenceManagerMock: LessonPersistenceManager {
    func saveItem(_ itemDto: LessonDTO) throws -> Lesson {
        return Lesson()
    }

    func fetchAllItems() throws -> [Lesson] {
        return []
    }

    func fetchAllItemsDTO() throws -> [LessonDTO] {
        return []
    }

    func clearAllItems() throws { }
}
