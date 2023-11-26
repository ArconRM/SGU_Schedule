//
//  LessonCoreDataManager.swift
//  Watch_SGU_Schedule Watch App
//
//  Created by Артемий on 18.11.2023.
//

import Foundation

struct LessonsCoreDataManager: LessonPersistenceManager {
    private let viewContext = PersistenceController.shared.container.viewContext
    
    func saveItem(item: LessonDTO) throws -> Lesson {
        do {
            let newLesson = Lesson(context: viewContext)
//            newLesson.id = UUID()
            newLesson.title = item.title
            newLesson.lectorFullName = item.lectorFullName
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
        }
        catch {
            throw CoreDataError.failedToSave
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
                                       lectorFullName: managedLesson.lectorFullName ?? "Error",
                                       lessonType: managedLesson.lessonType,
                                       weekDay: managedLesson.weekDay,
                                       weekType: managedLesson.weekType,
                                       cabinet: managedLesson.cabinet ?? "Error",
                                       lessonNumber: Int(managedLesson.lessonNumber),
                                       timeStart: managedLesson.timeStart ?? Date(),
                                       timeEnd: managedLesson.timeEnd ?? Date())
                resultLessons.append(resultLesson)
            }
            return resultLessons
        }
        catch {
            throw CoreDataError.failedToFetch
        }
    }
    
    func fetchAllManagedItems() throws -> [Lesson] {
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
    
    func clearAllItems() throws {
        do {
            let prevLessons = try self.fetchAllManagedItems()
            for lesson in prevLessons {
                viewContext.delete(lesson)
            }
            try viewContext.save()
        }
        catch {
            throw CoreDataError.failedToClear
        }
    }
}
