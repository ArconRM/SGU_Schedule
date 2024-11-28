//
//  LessonSubgroupsPersistenceManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 18.10.2024.
//

import Foundation

public protocol LessonSubgroupsPersistenceManager {

    func saveItem(lesson: String, item: LessonSubgroup) throws

    func saveDict(_ dict: [String: LessonSubgroup])

    /// Дефолтно проинициализирует (nil для всех пар) если не было сохранено ранее.
    /// Удалит записи для пар, которых уже нет в расписании.
    func getSavedSubgroups(lessonsInSchedule: [String]) -> [String: LessonSubgroup]

    /// Дефолтно проинициализирует (просто пустой словарь) если не было сохранено ранее.
    func getSavedSubgroups() -> [String: LessonSubgroup]

    func clearSaved()
}
