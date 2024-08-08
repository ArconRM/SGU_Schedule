//
//  SGU_ScheduleWidgetViewModel.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 03.08.2024.
//

import Foundation

// TODO: Объединить с ScheduleViewModel через какой-то общий интерфейс
public final class ScheduleWidgetViewModel: ObservableObject {
    
    private let schedulePersistenceManager: GroupSchedulePersistenceManager
    
    @Published var fetchResult = ScheduleFetchResult(resultVariant: .UnknownErrorWhileFetching)
    
    init(schedulePersistenceManager: GroupSchedulePersistenceManager) {
        self.schedulePersistenceManager = schedulePersistenceManager
    }
    
    public func fetchSavedSchedule() {
        do {
            let schedule = try self.schedulePersistenceManager.fetchAllItemsDTO().first
            if schedule == nil {
                fetchResult = ScheduleFetchResult(resultVariant: .NoFavoriteGroup)
            } else {
                let (currentEvent, nextLesson) = getCurrentAndNextLesson(schedule: schedule!)
                fetchResult = ScheduleFetchResult(resultVariant: .Success, currentEvent: currentEvent, nextLesson: nextLesson)
            }
        }
        catch {
            fetchResult = ScheduleFetchResult(resultVariant: .UnknownErrorWhileFetching)
        }
    }
    
    private func getCurrentAndNextLesson(schedule: GroupScheduleDTO) -> ((any ScheduleEventDTO)?, LessonDTO?) {
        // Проверяем есть ли вообще занятия
        let currentDayNumber = Date.currentWeekDay.number
        let currentTime = Date.currentHoursAndMinutes
        
        if currentDayNumber == 7 {
            return (nil, nil)
        }
        
        let todayLessons = schedule.lessons.filter { $0.weekDay.number == currentDayNumber && Date.checkIfWeekTypeIsAllOrCurrent($0.weekType) }
        if todayLessons.isEmpty {
            return (nil, nil)
        }
        
        for lessonNumber in 1...8 {
            let todayLessonsByNumber = todayLessons.filter { $0.lessonNumber == lessonNumber }
            if todayLessonsByNumber.isEmpty {
                continue
            }
            
            // Ищем пару
            if Date.checkIfTimeIsBetweenTwoTimes(dateStart: todayLessonsByNumber[0].timeStart,
                                            dateMiddle: currentTime,
                                            dateEnd: todayLessonsByNumber[0].timeEnd)
            {
                var currentLesson = todayLessonsByNumber[0]
                if todayLessonsByNumber.count > 1 { // Значит есть подгруппы и общего кабинета нет
                    currentLesson.cabinet = "По подгруппам"
                }
                return (currentLesson, getNextLesson(lessons: todayLessons, from: lessonNumber))
                
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
                                                    strictInequality: true)
                    {
                        let currentTimeBreak = TimeBreakDTO(timeStart: todayLessonsByNumber[0].timeEnd, timeEnd: todayLessonsByNumberNext[0].timeStart)
                        return (currentTimeBreak, getNextLesson(lessons: todayLessons, from: lessonNumber))
                    }
                    
                    if !todayLessonsByNumberNext.isEmpty {
                        break
                    }
                }
            }
        }
        
        return (nil, nil)
    }
    
    /// If possible, sets twoNextLessons to two nearest lessons from given array, which have greater lessonNumber than given one
    private func getNextLesson(lessons: [LessonDTO], from number: Int) -> LessonDTO? {
        for nextLessonNumber in (number + 1)...8 {
            let lessonsByNumber = lessons.filter { $0.lessonNumber == nextLessonNumber }
            if !lessonsByNumber.isEmpty {
                var nextLesson = lessonsByNumber[0]
                if lessonsByNumber.count > 1 {
                    nextLesson.cabinet = "По подгруппам"
                }
                return nextLesson
            }
        }
        return nil
    }
}
