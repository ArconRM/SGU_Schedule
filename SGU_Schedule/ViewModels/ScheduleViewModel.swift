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
    private let lessonSubgroupsPersistenceManager: LessonSubgroupsPersistenceManager
    
    @Published var groupSchedule: GroupScheduleDTO? = nil
    @Published var groupSessionEvents: GroupSessionEventsDTO? = nil
    @Published var subgroupsByLessons: [String: [LessonSubgroup]] = [:]
    //TODO: Убрать это
    @Published var savedSubgroupsCount = 0
    
    @Published var currentEvent: (any ScheduleEvent)? = nil
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
        schedulePersistenceManager: GroupSchedulePersistenceManager,
        lessonSubgroupsPersistenceManager: LessonSubgroupsPersistenceManager
    ) {
        self.lessonsNetworkManager = lessonsNetworkManager
        self.sessionEventsNetworkManager = sessionEventsNetworkManager
        self.schedulePersistenceManager = schedulePersistenceManager
        self.lessonSubgroupsPersistenceManager = lessonSubgroupsPersistenceManager
    }
    
    /// Если группа сохранена и в онлайне - получает расписание с networkManager.
    /// Если группа сохранена и расписание с CoreData различается с оным с networkManager - перезаписывает его.
    /// В иных случаях просто получает расписание с CoreData.
    public func fetchSchedule(group: AcademicGroupDTO, isOnline: Bool, isSaved: Bool, isFavourite: Bool) {
        resetData()
        
        do {
            // Если сохраненная группа
            if isSaved {
                let persistenceSchedule = try self.schedulePersistenceManager.getScheduleByGroupId(group.groupId)
                
                // Если есть сохраненное в память раннее, сначала ставится оно
                if persistenceSchedule != nil {
                    self.groupSchedule = persistenceSchedule
                    
                    if isFavourite {
                        fetchSubgroups()
                    }
                    self.setCurrentAndTwoNextLessons()
                }
                
                if isOnline {
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
                                
                                    if isFavourite {
                                        self.fetchSubgroups()
                                    }
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
        
        (currentEvent, nextLesson1, nextLesson2) = groupSchedule?.getCurrentAndNextLessons(subgroupsByLessons: self.subgroupsByLessons) ?? (nil, nil, nil)
    }
    
    /// Возвращает сохраненные, проставляет все
    private func fetchSubgroups() {
        if groupSchedule != nil {
            let savedSubgroups = lessonSubgroupsPersistenceManager.getSavedSubgroups(lessonsInSchedule: groupSchedule!.getUniqueLessonsTitles())
            savedSubgroupsCount = savedSubgroups.count
            self.subgroupsByLessons = groupSchedule!.getSubgroupsByLessons(savedSubgroups: savedSubgroups)
        }
    }
    
    public func saveSubgroup(lesson: String, subgroup: LessonSubgroup) {
        if let _ = self.subgroupsByLessons[lesson] {
            for subgroupIndex in subgroupsByLessons[lesson]!.indices {
                subgroupsByLessons[lesson]?[subgroupIndex].isSaved = subgroupsByLessons[lesson]?[subgroupIndex] == subgroup
            }
            
            do {
                try lessonSubgroupsPersistenceManager.saveItem(lesson: lesson, item: subgroup)
                let savedSubgroups = lessonSubgroupsPersistenceManager.getSavedSubgroups(lessonsInSchedule: groupSchedule!.getUniqueLessonsTitles())
                savedSubgroupsCount = savedSubgroups.count
            }
            catch {
                showUDError(error)
            }
        }
    }
    
    public func clearSubgroups() {
        lessonSubgroupsPersistenceManager.clearSaved()
        fetchSubgroups()
    }
    
//    private func setSavedSubgroups(savedDict: [String: LessonSubgroup]) {
//        for lesson in savedDict.keys {
//            if let _ = self.subgroupsByLessons[lesson] {
//                for subgroupIndex in subgroupsByLessons[lesson]!.indices {
//                    subgroupsByLessons[lesson]?[subgroupIndex].isSaved = subgroupsByLessons[lesson]?[subgroupIndex] == savedDict[lesson]
//                }
//            }
//        }
//    }
    
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
    
    private func showUDError(_ error: Error) {
        self.isShowingError = true
        
        if let udError = error as? UserDefaultsError {
            self.activeError = udError
        } else {
            self.activeError = UserDefaultsError.unexpectedError
        }
    }
}
