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
    
    public func getCurrentAndNextLessons() -> ((any ScheduleEventDTO)?, LessonDTO?, LessonDTO?) {
        // Проверяем есть ли вообще занятия
        let currentDayNumber = Date.currentWeekDay.number
        let currentTime = Date.currentHoursAndMinutes
        
        if currentDayNumber == 7 {
            return (nil, nil, nil)
        }
        
        let todayLessons = self.lessons.filter { $0.weekDay.number == currentDayNumber && Date.checkIfWeekTypeIsAllOrCurrentWithSundayBeingNextWeek($0.weekType) }
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
                        let currentTimeBreak = TimeBreakDTO(timeStart: todayLessonsByNumber[0].timeEnd, timeEnd: todayLessonsByNumberNext[0].timeStart, isWindow: nextLessonNumber - lessonNumber > 1)
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
    
    public func getFirstCloseToNowLesson() -> LessonDTO? {
        // Проверяем есть ли вообще занятия
        let currentDayNumber = Date.currentWeekDay.number
        let currentTime = Date.currentHoursAndMinutes
        
        if currentDayNumber == 7 {
            return nil
        }
        
        let todayLessons = self.lessons.filter { $0.weekDay.number == currentDayNumber && Date.checkIfWeekTypeIsAllOrCurrentWithSundayBeingNextWeek($0.weekType) }
        if todayLessons.isEmpty {
            return nil
        }
        
        for lessonNumber in 1...8 {
            let todayLessonsByNumber = todayLessons.filter { $0.lessonNumber == lessonNumber }
            if todayLessonsByNumber.isEmpty {
                continue
            } else {
                if isNextLessonNearNow(nextLesson: todayLessonsByNumber[0]) {
                    var closeLesson = todayLessonsByNumber[0]
                    if todayLessonsByNumber.count > 1 {
                        closeLesson.cabinet = "По подгруппам"
                    }
                    return closeLesson
                } else {
                    return nil
                }
            }
        }
        
        return nil
    }
    
    private func isNextLessonNearNow(nextLesson lesson: LessonDTO) -> Bool {
        return Date.checkIfWeekTypeIsAllOrCurrentWithSundayBeingNextWeek(lesson.weekType) &&
        lesson.timeStart.getHours() > Date().getHours() &&
        lesson.timeStart.getHours() - Date().getHours() <= 2
    }
}
