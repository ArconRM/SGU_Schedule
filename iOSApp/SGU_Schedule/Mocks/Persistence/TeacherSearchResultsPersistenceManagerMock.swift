//
//  TeacherSearchResultsPersistenceManagerMock.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation

final class TeacherSearchResultsPersistenceManagerMock: TeacherSearchResultsPersistenceManager {
    func save(_ results: Set<SGU_Schedule.TeacherSearchResult>) { }

    func getAll() -> Set<SGU_Schedule.TeacherSearchResult>? {
        return Set([])
    }
}
