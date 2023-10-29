//
//  LessonCoreDataManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.10.2023.
//

import Foundation
import SwiftUI

struct LessonsCoreDataManager: PersistenceManager {
    typealias DTOModel = LessonDTO
    typealias ManagedModel = Lesson
    
    private let viewContext = PersistenceController.shared.container.viewContext
    
    func saveItem(item: LessonDTO) throws {
        do {
            try withAnimation {
                let newLesson = Lesson(context: viewContext)
                newLesson.title = item.title
                newLesson.lectorFullName = item.lectorFullName
                newLesson.timeStart = item.timeStart
                newLesson.timeEnd = item.timeEnd
                newLesson.subgroup = item.subgroup
                newLesson.cabinet = item.cabinet
                
                newLesson.weekType = item.weekType
                newLesson.lessonType = item.lessonType
                
                try viewContext.save()
            }
        } 
        catch {
            throw CoreDataError.failedToSave
        }
    }
    
    func saveItems(items: [LessonDTO]) throws {
        do {
            for item in items {
                try saveItem(item: item)
            }
        }
        catch {
            throw CoreDataError.failedToSave
        }
    }
    
    func fetchAllItems() throws -> [LessonDTO] {
        do {
            let managedLessons = try viewContext.fetch(Lesson.fetchRequest())
            var resultLessons: [LessonDTO] = []
            for managedLesson in managedLessons {
                let lesson = LessonDTO(Subject: managedLesson.title ?? "Error",
                                       LectorFullName: managedLesson.lectorFullName ?? "Error",
                                       TimeStart: managedLesson.timeStart ?? Date(),
                                       TimeEnd: managedLesson.timeEnd ?? Date(),
                                       LessonType: managedLesson.lessonType,
                                       WeekType: managedLesson.weekType,
                                       Subgroup: managedLesson.subgroup,
                                       Cabinet: managedLesson.cabinet ?? "Error")
                resultLessons.append(lesson)
            }
            return resultLessons
        } 
        catch {
            throw CoreDataError.failedToFetch
        }
    }
    
    func clearAllItems() throws {
        do {
            let prevLessons = try self._fetchAllManagedItems()
            for lesson in prevLessons {
                viewContext.delete(lesson)
            }
            try viewContext.save()
        }
        catch {
            throw CoreDataError.failedToClear
        }
    }
    
    private func _fetchAllManagedItems() throws -> [Lesson] {
        do {
            let lessons = try viewContext.fetch(Lesson.fetchRequest())
            return lessons
        } catch {
            throw CoreDataError.failedToFetch
        }
    }
}
