//
//  TeacherSearchResultsPersistenceManagerMock.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation
import SguParser

final class TeacherSearchResultsPersistenceManagerMock: TeacherSearchResultsPersistenceManager {
    func save(_ results: Set<SguParser.TeacherSearchResult>) { }

    func getAll() -> Set<SguParser.TeacherSearchResult>? {
        return Set([])
    }
}
