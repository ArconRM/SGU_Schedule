//
//  GroupScheduleDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 03.11.2023.
//

import Foundation

public struct GroupScheduleDTO {
    
    var group: AcademicGroupDTO
    var lessons: [LessonDTO]
    
    init(groupNumber: String, departmentCode: String, lessonsByDays: [LessonDTO]) {
        self.group = AcademicGroupDTO(fullNumber: groupNumber, departmentCode: departmentCode)
        self.lessons = lessonsByDays
    }
    
    public func getTodayFirstLesson(subgroupsByLessons: [String: [LessonSubgroup]]) -> LessonDTO? {
        let currentWeekDayNumber = Date.currentWeekDay.number
        
        let todayLessons = self.lessons.filter { $0.weekDay.number == currentWeekDayNumber && $0.isActive(subgroupsByLessons: subgroupsByLessons) }
        if todayLessons.isEmpty {
            return nil
        }
        
        for lessonNumber in 1...8 {
            let todayLessonsByNumber = todayLessons.filter { $0.lessonNumber == lessonNumber }
            if todayLessonsByNumber.isEmpty {
                continue
            }
            return todayLessonsByNumber.first
        }
        
        return nil
    }
    
    public func getCurrentAndNextLessons(subgroupsByLessons: [String: [LessonSubgroup]]) -> ((any ScheduleEvent)?, LessonDTO?, LessonDTO?) {
        // Проверяем есть ли вообще занятия
        let currentWeekDayNumber = Date.currentWeekDay.number
        let currentTime = Date.currentHoursAndMinutes
        
//        if currentDayNumber == 7 {
//            return (nil, nil, nil)
//        }
        
        let todayLessons = self.lessons.filter { $0.weekDay.number == currentWeekDayNumber && $0.isActive(subgroupsByLessons: subgroupsByLessons) }
        if todayLessons.isEmpty {
            return (nil, nil, nil)
        }
        
        for lessonNumber in 1...8 {
            let todayLessonsByNumber = todayLessons.filter { $0.lessonNumber == lessonNumber }
            if todayLessonsByNumber.isEmpty {
                continue
            }
            
            // Ищем пару
            if Date.checkIfTimeIsBetweenTwoTimes(dateStart: todayLessonsByNumber[0].timeStart,
                                                 dateMiddle: currentTime,
                                                 dateEnd: todayLessonsByNumber[0].timeEnd) {
                var currentLesson = todayLessonsByNumber[0]
                if todayLessonsByNumber.count > 1 { // Значит есть подгруппы и общего кабинета нет
                    currentLesson.cabinet = "По подгруппам"
                }
                return (currentLesson, 
                        getNextTwoLessons(lessons: todayLessons, from: lessonNumber).0,
                        getNextTwoLessons(lessons: todayLessons, from: lessonNumber).1)
                
                // Ищем перемену
            } else if lessonNumber != 8 { // Смотрим следующую пару, когда находим - выходим
                for nextLessonNumber in (lessonNumber + 1)...8 {
                    let todayLessonsByNumberNext = todayLessons.filter { $0.lessonNumber == nextLessonNumber }
                    if todayLessonsByNumberNext.isEmpty {
                        continue
                    }
                    
                    if Date.checkIfTimeIsBetweenTwoTimes(dateStart: todayLessonsByNumber[0].timeEnd,
                                                         dateMiddle: currentTime,
                                                         dateEnd: todayLessonsByNumberNext[0].timeStart,
                                                         strictInequality: true) {
                        let currentTimeBreak = TimeBreak(timeStart: todayLessonsByNumber[0].timeEnd, timeEnd: todayLessonsByNumberNext[0].timeStart, isWindow: nextLessonNumber - lessonNumber > 1)
                        return (currentTimeBreak, 
                                getNextTwoLessons(lessons: todayLessons, from: lessonNumber).0,
                                getNextTwoLessons(lessons: todayLessons, from: lessonNumber).1)
                    }
                    
                    if !todayLessonsByNumberNext.isEmpty {
                        break
                    }
                }
            }
        }
        
        return (nil, nil, nil)
    }
    
    /// If possible, sets twoNextLessons to two nearest lessons from given array, which have greater lessonNumber than given one
    private func getNextTwoLessons(lessons: [LessonDTO], from number: Int) -> (LessonDTO?, LessonDTO?) {
        var nextLesson1: LessonDTO? = nil
        var nextLesson2: LessonDTO? = nil
        
        for nextLessonNumber in (number + 1)...8 {
            let lessonsByNumber = lessons.filter { $0.lessonNumber == nextLessonNumber }
            if !lessonsByNumber.isEmpty {
                if nextLesson1 == nil {
                    var newNextLesson = lessonsByNumber[0]
                    if lessonsByNumber.count > 1 {
                        newNextLesson.cabinet = "По подгруппам"
                    }
                    nextLesson1 = newNextLesson
                } else if nextLesson2 == nil {
                    var newNextLesson = lessonsByNumber[0]
                    if lessonsByNumber.count > 1 {
                        newNextLesson.cabinet = "По подгруппам"
                    }
                    nextLesson2 = newNextLesson
                }
            }
        }
        return (nextLesson1, nextLesson2)
    }
    
    public func getSubgroupsByLessons(savedSubgroups: [String: LessonSubgroup]) -> [String: [LessonSubgroup]] {
        var subgroupsByLessons: [String: [LessonSubgroup]] = [:]
        for lesson in self.lessons {
            if lesson.subgroup != nil && !lesson.subgroup!.isEmpty {
                let isSaved = savedSubgroups[lesson.title] != nil && savedSubgroups[lesson.title]?.number == lesson.subgroup
                if subgroupsByLessons[lesson.title] != nil && !subgroupsByLessons[lesson.title]!.contains(where: { $0.number == lesson.subgroup }) {
                    subgroupsByLessons[lesson.title]!.append(LessonSubgroup(teacher: lesson.teacherFullName, number: lesson.subgroup!, isSaved: isSaved))
                } else {
                    subgroupsByLessons[lesson.title] = [LessonSubgroup(teacher: lesson.teacherFullName, number: lesson.subgroup!, isSaved: isSaved)]
                }
            }
        }
        return subgroupsByLessons.filter({ $0.value.count > 1 }).mapValues({ $0.sorted(by: { $0.displayNumber < $1.displayNumber })})
    }
    
    public func getUniqueLessonsTitles() -> [String] {
        var result: [String] = []
        for lesson in self.lessons {
            if !result.contains(lesson.title) {
                result.append(lesson.title)
            }
        }
        return result
    }
}
