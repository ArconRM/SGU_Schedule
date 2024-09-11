//
//  GroupScheduleCoreDataManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 03.11.2023.
//

import Foundation

struct GroupScheduleCoreDataManager: GroupSchedulePersistenceManager {
    private let viewContext = PersistenceController.shared.container.viewContext
    private let lessonsManager = LessonCoreDataManager()
    private let groupsManager = GroupCoreDataManager()
    
    func saveItem(_ itemDto: GroupScheduleDTO) throws -> GroupSchedule {
        do {
            let schedule = GroupSchedule(context: viewContext)
            if let group = try groupsManager.fetchAllItems().first(where: { $0.groupId == itemDto.group.groupId }) {
                schedule.group = group
            } else {
              throw CoreDataError.failedToSave
            }
            
            var newLessons: [Lesson] = []
            for lesson in itemDto.lessons {
                newLessons.append(try lessonsManager.saveItem(lesson))
            }
            schedule.lessons = NSOrderedSet(array: newLessons)
            
            try viewContext.save()
            return schedule
        }
        catch {
            throw CoreDataError.failedToSave
        }
    }
    
    func fetchAllItems() throws -> [GroupSchedule] {
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
                    let lessonDto = LessonDTO(subject: managedLesson.title ?? "Error",
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
                    resultLessons.append(lessonDto)
                }
                
                resultSchedules.append(
                    GroupScheduleDTO(
                        groupNumber: managedSchedule.group?.fullNumber ?? "Error",
                        departmentCode: managedSchedule.group?.departmentCode ?? "Error",
                        lessonsByDays: resultLessons
                    )
                )
            }
            return resultSchedules
        }
        catch {
            throw CoreDataError.failedToFetch
        }
    }
    
    func getFavouriteGroupScheduleDTO() throws -> GroupScheduleDTO? {
        do {
            if try viewContext.count(for: GroupSchedule.fetchRequest()) == 0 {
                return nil
            }
            
            guard let managedSchedule = try viewContext.fetch(GroupSchedule.fetchRequest()).first(where: { $0.group?.isFavourite ?? false }) else {
                return nil
            }
            
            var resultLessons: [LessonDTO] = []
            for managedLesson in managedSchedule.lessons?.array as! [Lesson] {
                let lessonDto = LessonDTO(subject: managedLesson.title ?? "Error",
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
                resultLessons.append(lessonDto)
            }
            
            return GroupScheduleDTO(
                groupNumber: managedSchedule.group?.fullNumber ?? "Error",
                departmentCode: managedSchedule.group?.departmentCode ?? "Error",
                lessonsByDays: resultLessons
            )
        }
        catch {
            throw CoreDataError.failedToFetch
        }
    }
    
    
    func getScheduleByGroupId(_ groupId: String) throws -> GroupScheduleDTO? {
        do {
            if try viewContext.count(for: GroupSchedule.fetchRequest()) == 0 {
                return nil
            }
            
            guard let managedSchedule = try viewContext.fetch(GroupSchedule.fetchRequest()).first(where: { $0.group?.groupId == groupId }) else {
                return nil
            }
            
            var resultLessons: [LessonDTO] = []
            for managedLesson in managedSchedule.lessons?.array as! [Lesson] {
                let lessonDto = LessonDTO(subject: managedLesson.title ?? "Error",
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
                resultLessons.append(lessonDto)
            }
            
            return GroupScheduleDTO(
                groupNumber: managedSchedule.group?.fullNumber ?? "Error",
                departmentCode: managedSchedule.group?.departmentCode ?? "Error",
                lessonsByDays: resultLessons
            )
        }
        catch {
            throw CoreDataError.failedToFetch
        }
    }
    
    func clearAllItems() throws {
        do {
            if try viewContext.count(for: GroupSchedule.fetchRequest()) == 0 {
                return
            }
            
            let prevSchedules = try self.fetchAllItems()
            for schedule in prevSchedules {
                viewContext.delete(schedule)
            }
            
            try viewContext.save()
        }
        catch {
            throw CoreDataError.failedToDelete
        }
    }
    
    // Если не нашел такую группу, просто ничего не делает
    func deleteScheduleByGroupId(_ groupId: String) throws {
        do {
            if try viewContext.count(for: GroupSchedule.fetchRequest()) == 0 {
                return
            }
            
            guard let managedSchedule = try viewContext.fetch(GroupSchedule.fetchRequest()).first(where: { $0.group?.groupId == groupId }) else {
                return
            }
            viewContext.delete(managedSchedule)
            
            try viewContext.save()
        }
        catch {
            throw CoreDataError.failedToDelete
        }
    }
}
