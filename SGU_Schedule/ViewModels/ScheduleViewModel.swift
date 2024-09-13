//
//  ScheduleViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 07.10.2023.
//

import Foundation
import WidgetKit

public final class ScheduleViewModel: ObservableObject {
    private let lessonsNetworkManager: LessonNetworkManager
    private let sessionEventsNetworkManager: SessionEventsNetworkManager
    private let schedulePersistenceManager: GroupSchedulePersistenceManager
    
    @Published var groupSchedule: GroupScheduleDTO?
    @Published var currentEvent: (any ScheduleEventDTO)? = nil
    @Published var groupSessionEvents: GroupSessionEventsDTO?
    
    @Published var nextLesson1: LessonDTO? = nil
    @Published var nextLesson2: LessonDTO? = nil
    
    @Published var isLoadingLessons = true
    @Published var loadedLessonsWithChanges = false
    @Published var isLoadingSessionEvents = true
    
    @Published var isShowingError = false
    @Published var activeError: LocalizedError?
    
    init(
        lessonsNetworkManager: LessonNetworkManager,
        sessionEventsNetworkManager: SessionEventsNetworkManager,
        schedulePersistenceManager: GroupSchedulePersistenceManager
    ) {
        self.lessonsNetworkManager = lessonsNetworkManager
        self.sessionEventsNetworkManager = sessionEventsNetworkManager
        self.schedulePersistenceManager = schedulePersistenceManager
    }
    
    /// Если группа сохранена и в онлайне - получает расписание с networkManager.
    /// Если группа сохранена и расписание с CoreData различается с оным с networkManager - перезаписывает его.
    /// В иных случаях просто получает расписание с CoreData.
    public func fetchSchedule(group: AcademicGroupDTO, isOnline: Bool, isSaved: Bool) {
        resetData()
        
        do {
            // Если сохраненная группа
            if isSaved {
                let persistenceSchedule = try self.schedulePersistenceManager.getScheduleByGroupId(group.groupId)
                
                if persistenceSchedule != nil {
                    self.groupSchedule = persistenceSchedule
                    self.setCurrentAndTwoNextLessons()
                }
                
                if isOnline {
                    // Если есть сохраненное в память раннее, сначала ставится оно
                    if persistenceSchedule != nil {
                        self.groupSchedule = persistenceSchedule
                        self.setCurrentAndTwoNextLessons()
                    }
                    // Получение расписания через networkManager и сравнение его с сохраненным (если оно есть)
                    self.lessonsNetworkManager.getGroupScheduleForCurrentWeek (
                        group: group,
                        resultQueue: DispatchQueue.main
                    ) { result in
                        switch result {
                        case .success(let networkSchedule):
                            do {
                                if persistenceSchedule == nil || networkSchedule.lessons != persistenceSchedule!.lessons {
                                    self.groupSchedule = networkSchedule
                                    try self.saveNewScheduleWithDeletingPreviousVersion(schedule: networkSchedule)
                                    self.setCurrentAndTwoNextLessons()
                                    
                                    if persistenceSchedule != nil && networkSchedule.lessons != persistenceSchedule!.lessons {
                                        self.loadedLessonsWithChanges = true
                                    }
                                } else {
                                    self.groupSchedule = persistenceSchedule
                                }
                                
                                self.isLoadingLessons = false
                            }
                            catch (let error) {
                                self.showCoreDataError(error)
                            }
                            
                        case .failure(let error):
                            self.showNetworkError(error)
                        }
                    }
                }
            
            // Если не сохраненная группа
            } else {
                self.lessonsNetworkManager.getGroupScheduleForCurrentWeek(
                    group: group,
                    resultQueue: DispatchQueue.main
                ) { result in
                    switch result {
                    case .success(let schedule):
                        self.groupSchedule = schedule
                        self.setCurrentAndTwoNextLessons()
                        
                    case .failure(let error):
                        self.showNetworkError(error)
                    }
                    
                    self.isLoadingLessons = false
                }
            }
            
            WidgetCenter.shared.reloadAllTimelines()
        }
        catch (let error) {
            self.showCoreDataError(error)
        }
    }
    
    public func fetchSessionEvents(group: AcademicGroupDTO, isOnline: Bool) {
        if isOnline {
            sessionEventsNetworkManager.getGroupSessionEvents(
                group: group,
                resultQueue: .main
            ) { result in
                switch result {
                case .success(let date):
                    self.groupSessionEvents = date
                case .failure(let error):
                    self.showNetworkError(error)
                }
                self.isLoadingSessionEvents = false
            }
        }
    }
    
    public func resetData() {
        currentEvent = nil
        nextLesson1 = nil
        nextLesson2 = nil
        
        isLoadingLessons = true
        isLoadingSessionEvents = true
    }
    
    private func showNetworkError(_ error: Error) {
        self.isShowingError = true
        
        if let networkError = error as? NetworkError {
            self.activeError = networkError
        } else {
            self.activeError = NetworkError.unexpectedError
        }
    }
    
    private func showCoreDataError(_ error: Error) {
        self.isShowingError = true
        
        if let coreDataError = error as? CoreDataError {
            self.activeError = coreDataError
        } else {
            self.activeError = CoreDataError.unexpectedError
        }
    }
    
    private func saveNewScheduleWithDeletingPreviousVersion(schedule: GroupScheduleDTO) throws {
        try self.schedulePersistenceManager.deleteScheduleByGroupId(schedule.group.groupId)
        try self.schedulePersistenceManager.saveItem(schedule)
    }
    
    private func setCurrentAndTwoNextLessons() {
        currentEvent = nil
        nextLesson1 = nil
        nextLesson2 = nil
        
        if groupSchedule == nil {
            return
        }
        
        let currentDayNumber = Date.currentWeekDay.number
        let currentTime = Date.currentHoursAndMinutes
        
        if currentDayNumber == 7 {
            return
        }
        
        let todayLessons = groupSchedule!.lessons.filter { $0.weekDay.number == currentDayNumber && Date.checkIfWeekTypeIsAllOrCurrent($0.weekType) }
        if todayLessons.isEmpty {
            return
        }
        
        for lessonNumber in 1...8 {
            let todayLessonsByNumber = todayLessons.filter { $0.lessonNumber == lessonNumber }
            if todayLessonsByNumber.isEmpty {
                continue
            }
            
            // ищем пару
            if Date.checkIfTimeIsBetweenTwoTimes(dateStart: todayLessonsByNumber[0].timeStart,
                                            dateMiddle: currentTime,
                                            dateEnd: todayLessonsByNumber[0].timeEnd)
            {
                var newCurrentLesson = todayLessonsByNumber[0]
                if todayLessonsByNumber.count > 1 { // значит есть подгруппы и общего кабинета нет
                    newCurrentLesson.cabinet = "По подгруппам"
                }
                currentEvent = newCurrentLesson
                setNextTwoLessons(lessons: todayLessons, from: lessonNumber)
                return
                
                // ищем перемену
            } else if lessonNumber != 8 { // смотрим следующую пару, когда находим - выходим
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
                        currentEvent = TimeBreakDTO(timeStart: todayLessonsByNumber[0].timeEnd, timeEnd: todayLessonsByNumberNext[0].timeStart)
                        setNextTwoLessons(lessons: todayLessons, from: lessonNumber)
                    }
                    
                    if !todayLessonsByNumberNext.isEmpty {
                        break
                    }
                }
            }
        }
    }
    
    /// Если есть подходящие пары, ставит twoNextLessons как две ближайшие пары с массива, у которых номер больше переданного
    private func setNextTwoLessons(lessons: [LessonDTO], from number: Int) {
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
    }
}
