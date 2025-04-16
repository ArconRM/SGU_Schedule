//
//  LessonSubgroupsPersistenceManagerMock.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation

final class LessonSubgroupsPersistenceManagerMock: LessonSubgroupsPersistenceManager {
    func saveItem(lesson: String, item: LessonSubgroupDTO) throws { }

    func saveDict(_ dict: [String: LessonSubgroupDTO]) { }

    func getSavedSubgroups(lessonsInSchedule: [String]) -> [String: LessonSubgroupDTO] {
        return [:]
    }

    func getSavedSubgroups() -> [String: LessonSubgroupDTO] {
        return [:]
    }

    func clearSaved() { }
}
