//
//  GroupScheduleCoreDataManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 03.11.2023.
//

import Foundation

struct GroupScheduleCoreDataManager: GroupSchedulePersistenceManager {
    private let viewContext = PersistenceController.shared.container.viewContext
    private let lessonsManager = LessonsCoreDataManager()
    
    func saveItem(item: GroupScheduleDTO) throws -> GroupSchedule {
        do {
            let schedule = GroupSchedule(context: viewContext)
            schedule.groupNumber = Int16(item.group.fullNumber)
            
            var newLessons: [Lesson] = []
            for lesson in item.lessons {
                newLessons.append(try lessonsManager.saveItem(item: lesson))
            }
            schedule.lessons = NSOrderedSet(array: newLessons)
            
            try viewContext.save()
            return schedule
        }
        catch {
            throw CoreDataError.failedToSave
        }
    }
    
    func fetchAllItemsDTO() throws -> [GroupScheduleDTO] {
        do {
            if try viewContext.count(for: GroupSchedule.fetchRequest()) == 0 {
                return []
            }
            
            let managedSchedules = try viewContext.fetch(GroupSchedule.fetchRequest())
            var resultSchedules = [GroupScheduleDTO]()
            
            for managedSchedule in managedSchedules {
                var resultLessons: [LessonDTO] = []
                
                for managedLesson in managedSchedule.lessons?.array as! [Lesson] {
                    let resultLesson = LessonDTO(subject: managedLesson.title ?? "Error",
                                                 lectorFullName: managedLesson.lectorFullName ?? "Error",
                                                 lectorUrl: managedLesson.lectorUrl,
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
                
                resultSchedules.append(GroupScheduleDTO(groupNumber: Int(managedSchedule.groupNumber), lessonsByDays: resultLessons))
            }
            return resultSchedules
        }
        catch {
            throw CoreDataError.failedToFetch
        }
    }
    
    func fetchAllManagedItems() throws -> [GroupSchedule] {
        do {
            if try viewContext.count(for: GroupSchedule.fetchRequest()) == 0 {
                return []
            }
            
            let schedules = try viewContext.fetch(GroupSchedule.fetchRequest())
            return schedules
        } catch {
            throw CoreDataError.failedToFetch
        }
    }
    
    func clearAllItems() throws {
        do {
            if try viewContext.count(for: GroupSchedule.fetchRequest()) == 0 {
                return
            }
            
            let prevSchedules = try self.fetchAllManagedItems()
            for schedule in prevSchedules {
                viewContext.delete(schedule)
            }
            try viewContext.save()
        }
        catch {
            throw CoreDataError.failedToClear
        }
    }
}
