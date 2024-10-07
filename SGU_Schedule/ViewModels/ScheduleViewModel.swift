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
        
        (currentEvent, nextLesson1, nextLesson2) = groupSchedule?.getCurrentAndNextLessons() ?? (nil, nil, nil)
    }
}
