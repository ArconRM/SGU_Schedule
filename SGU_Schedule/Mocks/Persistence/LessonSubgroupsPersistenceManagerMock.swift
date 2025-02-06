//
//  LessonSubgroupsPersistenceManagerMock.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation

final class LessonSubgroupsPersistenceManagerMock: LessonSubgroupsPersistenceManager {
    func saveItem(lesson: String, item: LessonSubgroup) throws { }

    func saveDict(_ dict: [String: LessonSubgroup]) { }

    func getSavedSubgroups(lessonsInSchedule: [String]) -> [String: LessonSubgroup] {
        return [:]
    }

    func getSavedSubgroups() -> [String: LessonSubgroup] {
        return [:]
    }

    func clearSaved() { }
}
