//
//  TeacherSearchResultsUDManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 10.11.2024.
//

import Foundation

public struct TeacherSearchResultsUDManager: TeacherSearchResultsPersistenceManager {
    private let teacherResultsKey = UserDefaultsKeys.teacherSearchResultsKey.rawValue
    private let defaults = UserDefaults(suiteName: AppGroup.schedule.rawValue) ?? UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public func save(_ results: Set<TeacherSearchResult>) {
        if let encoded = try? encoder.encode(results) {
            defaults.set(encoded, forKey: teacherResultsKey)
        }
    }

    public func getAll() -> Set<TeacherSearchResult>? {
        if let saved = defaults.object(forKey: teacherResultsKey) as? Data {
            if let decoded = try? decoder.decode(Set<TeacherSearchResult>.self, from: saved) {
                return decoded
            }
        }
        return nil
    }
}
