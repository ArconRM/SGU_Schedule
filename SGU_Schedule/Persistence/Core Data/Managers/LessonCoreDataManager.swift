//
//  LessonCoreDataManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.10.2023.
//

import Foundation
import SwiftUI

struct LessonCoreDataManager: LessonPersistenceManager {
    private let viewContext = PersistenceController.shared.container.viewContext

    func saveItem(_ item: LessonDTO) throws -> Lesson {
        do {
            let newLesson = Lesson(context: viewContext)
            newLesson.title = item.title
            newLesson.teacherFullName = item.teacherFullName
            newLesson.teacherEndpoint = item.teacherEndpoint
            newLesson.timeStart = item.timeStart
            newLesson.timeEnd = item.timeEnd
            newLesson.subgroup = item.subgroup
            newLesson.cabinet = item.cabinet
            newLesson.weekDay = item.weekDay
            newLesson.lessonNumber = Int16(item.lessonNumber)
            newLesson.weekType = item.weekType
            newLesson.lessonType = item.lessonType

            try viewContext.save()

            return newLesson
        } catch {
            throw CoreDataError.failedToSave
        }
    }

    func fetchAllItems() throws -> [Lesson] {
        do {
            if try viewContext.count(for: Lesson.fetchRequest()) == 0 {
                return []
            }

            let lessons = try viewContext.fetch(Lesson.fetchRequest())
            return lessons
        } catch {
            throw CoreDataError.failedToFetch
        }
    }

    func fetchAllItemsDTO() throws -> [LessonDTO] {
        do {
            if try viewContext.count(for: Lesson.fetchRequest()) == 0 {
                return []
            }

            let managedLessons = try viewContext.fetch(Lesson.fetchRequest())
            var resultLessons: [LessonDTO] = []
            for managedLesson in managedLessons {
                let resultLesson = LessonDTO(subject: managedLesson.title ?? "Error",
                                             teacherFullName: managedLesson.teacherFullName ?? "Error",
                                             teacherEndpoint: managedLesson.teacherEndpoint,
                                             lessonType: managedLesson.lessonType,
                                             weekDay: managedLesson.weekDay,
                                             weekType: managedLesson.weekType,
                                             cabinet: managedLesson.cabinet ?? "Error",
                                             subgroup: managedLesson.subgroup,
                                             lessonNumber: Int(managedLesson.lessonNumber),
                                             timeStart: managedLesson.timeStart ?? Date(),
                                             timeEnd: managedLesson.timeEnd ?? Date())
                resultLessons.append(resultLesson)
            }
            return resultLessons
        } catch {
            throw CoreDataError.failedToFetch
        }
    }

    func clearAllItems() throws {
        do {
            let prevLessons = try self.fetchAllItems()
            for lesson in prevLessons {
                viewContext.delete(lesson)
            }
            try viewContext.save()
        } catch {
            throw CoreDataError.failedToDelete
        }
    }
}
