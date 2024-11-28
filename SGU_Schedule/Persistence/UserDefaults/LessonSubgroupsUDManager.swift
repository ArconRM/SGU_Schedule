//
//  LessonSubgroupsUDManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 18.10.2024.
//

import Foundation

public struct LessonSubgroupsUDManager: LessonSubgroupsPersistenceManager {
    private let subgroupsKey = UserDefaultsKeys.favouriteGroupSubgroupsKey.rawValue
    private let defaults = UserDefaults(suiteName: "group.com.qwerty.SGUSchedule") ?? UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public func saveItem(lesson: String, item: LessonSubgroup) throws {
        var prevSaved = getSavedSubgroups()
        prevSaved[lesson] = item
        prevSaved[lesson]!.isSaved = true

        if let encoded = try? encoder.encode(prevSaved) {
            defaults.set(encoded, forKey: subgroupsKey)
        }
    }

    public func saveDict(_ dict: [String: LessonSubgroup]) {
        if let encoded = try? encoder.encode(dict) {
            defaults.set(encoded, forKey: subgroupsKey)
        }
    }

    public func getSavedSubgroups(lessonsInSchedule: [String]) -> [String: LessonSubgroup] {
        if let saved = defaults.object(forKey: subgroupsKey) as? Data {
            if var decoded = try? decoder.decode([String: LessonSubgroup].self, from: saved) {
                for savedLesson in decoded.keys where !lessonsInSchedule.contains(savedLesson) {
                    decoded.removeValue(forKey: savedLesson)
                }
                saveDict(decoded)
                return decoded
            }
            return [:]
        } else {
            var defaultDict: [String: LessonSubgroup] = [:]
            for lesson in lessonsInSchedule {
                defaultDict[lesson] = nil
            }
            saveDict(defaultDict)
            return defaultDict
        }
    }

    public func getSavedSubgroups() -> [String: LessonSubgroup] {
        if let saved = defaults.object(forKey: subgroupsKey) as? Data {
            if let decoded = try? decoder.decode([String: LessonSubgroup].self, from: saved) {
                return decoded
            }
            return [:]
        } else {
            saveDict([:])
            return [:]
        }
    }

    public func clearSaved() {
        defaults.set([:], forKey: subgroupsKey)
    }
}
