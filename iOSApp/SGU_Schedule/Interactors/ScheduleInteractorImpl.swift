//
//  ScheduleInteractorImpl.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 17.04.2025.
//

import Foundation
import SguParser

struct ScheduleInteractorImpl: ScheduleInteractor {
    private let lessonsNetworkManager: LessonNetworkManager
    private let sessionEventsNetworkManager: SessionEventsNetworkManager

    private let groupSchedulePersistenceManager: GroupSchedulePersistenceManager
    private let lessonSubgroupsPersistenceManager: LessonSubgroupsPersistenceManager
    private let groupSessionEventsPersistenceManager: GroupSessionEventsPersistenceManager

    init(
        lessonsNetworkManager: LessonNetworkManager,
        sessionEventsNetworkManager: SessionEventsNetworkManager,
        groupSchedulePersistenceManager: GroupSchedulePersistenceManager,
        lessonSubgroupsPersistenceManager: LessonSubgroupsPersistenceManager,
        groupSessionEventsPersistenceManager: GroupSessionEventsPersistenceManager
    ) {
        self.lessonsNetworkManager = lessonsNetworkManager
        self.sessionEventsNetworkManager = sessionEventsNetworkManager
        self.groupSchedulePersistenceManager = groupSchedulePersistenceManager
        self.lessonSubgroupsPersistenceManager = lessonSubgroupsPersistenceManager
        self.groupSessionEventsPersistenceManager = groupSessionEventsPersistenceManager
    }

    /// Возвращает расписание, если есть его версия, сохраненная в память
    func fetchSavedSchedule(
        group: AcademicGroupDTO,
        isSaved: Bool,
        completionHandler: @escaping (Result<GroupScheduleFetchResult, any Error>) -> Void
    ) {
        do {
            if isSaved {
                let persistenceSchedule = try groupSchedulePersistenceManager.getScheduleByGroupId(group.groupId)

                if persistenceSchedule != nil {
                    DispatchQueue.main.async {
                        completionHandler(
                            .success(GroupScheduleFetchResult(groupSchedule: persistenceSchedule, loadedWithChanges: false))
                        )
                    }
                }
            }
        } catch let error {
            DispatchQueue.main.async { completionHandler(.failure(error)) }
        }
    }

    /// Если группа сохранена и в онлайне - получает расписание с networkManager.
    /// Если группа сохранена и сохраненное расписание различается с оным с networkManager - перезаписывает его.
    /// В иных случаях просто ставит расписание с networkManager.
    func fetchSchedule(
        group: AcademicGroupDTO,
        isOnline: Bool,
        isSaved: Bool,
        isFavourite: Bool,
        completionHandler: @escaping (Result<GroupScheduleFetchResult, Error>) -> Void
    ) {
        do {
            // Если сохраненная группа
            if isSaved {
                let persistenceSchedule = try groupSchedulePersistenceManager.getScheduleByGroupId(group.groupId)

                if isOnline {
                    // Получение расписания через networkManager и сравнение его с сохраненным (если оно есть)
                    self.lessonsNetworkManager.getGroupScheduleForCurrentWeek(
                        group: group,
                        resultQueue: DispatchQueue.main
                    ) { result in
                        switch result {
                        case .success(let networkSchedule):
                            do {
                                if persistenceSchedule == nil ||
                                    Set(networkSchedule.lessons) != Set(persistenceSchedule!.lessons) ||
                                    networkSchedule.lastUpdated != persistenceSchedule?.lastUpdated {

                                    DispatchQueue.main.async {
                                        let loadedLessonsWithChanges = persistenceSchedule != nil && Set(networkSchedule.lessons) != Set(persistenceSchedule!.lessons)
                                        completionHandler(
                                            .success(GroupScheduleFetchResult(groupSchedule: networkSchedule, loadedWithChanges: loadedLessonsWithChanges))
                                        )
                                    }

                                    try saveNewScheduleWithDeletingPreviousVersion(schedule: networkSchedule)

                                } else {
                                    DispatchQueue.main.async {
                                        completionHandler(
                                            .success(GroupScheduleFetchResult(groupSchedule: persistenceSchedule, loadedWithChanges: false))
                                        )
                                    }
                                }

                            } catch let error {
                                DispatchQueue.main.async { completionHandler(.failure(error)) }
                            }

                        case .failure(let error):
                            DispatchQueue.main.async { completionHandler(.failure(error)) }
                        }
                    }
                }

                // Если не сохраненная группа
            } else if isOnline {
                self.lessonsNetworkManager.getGroupScheduleForCurrentWeek(
                    group: group,
                    resultQueue: DispatchQueue.main
                ) { result in
                    switch result {
                    case .success(let schedule):
                        DispatchQueue.main.async {
                            completionHandler(
                                .success(GroupScheduleFetchResult(groupSchedule: schedule, loadedWithChanges: false))
                            )
                        }

                    case .failure(let error):
                        DispatchQueue.main.async { completionHandler(.failure(error)) }
                    }
                }
            }
        } catch let error {
            DispatchQueue.main.async { completionHandler(.failure(error)) }
        }
    }

    private func saveNewScheduleWithDeletingPreviousVersion(schedule: GroupScheduleDTO) throws {
        try self.groupSchedulePersistenceManager.deleteScheduleByGroupId(schedule.group.groupId)
        try self.groupSchedulePersistenceManager.saveItem(schedule)
    }

    func fetchSubgroupsByLessons(schedule: GroupScheduleDTO) -> [String: [LessonSubgroupDTO]] {
        let savedSubgroups = lessonSubgroupsPersistenceManager.getSavedSubgroups(lessonsInSchedule: schedule.getUniqueLessonsTitles())
        return schedule.getSubgroupsByLessons(savedSubgroups: savedSubgroups)
    }

    func saveSubgroup(
        groupSchedule: GroupScheduleDTO,
        subgroupsByLessons: [String: [LessonSubgroupDTO]],
        lesson: String,
        subgroup: LessonSubgroupDTO
    ) throws -> [String: [LessonSubgroupDTO]] {
        var result = subgroupsByLessons

        if var subgroups = result[lesson] {
            for index in subgroups.indices {
                subgroups[index].isSaved = subgroups[index] == subgroup
            }
            result[lesson] = subgroups

            try lessonSubgroupsPersistenceManager.saveItem(lesson: lesson, item: subgroup)
        }

        return result
    }

    func clearSubgroups() {
        lessonSubgroupsPersistenceManager.clearSaved()
    }

    func fetchSavedSessionEvents(group: AcademicGroupDTO, isSaved: Bool, completionHandler: @escaping (Result<GroupSessionEventsFetchResult, any Error>) -> Void) {
        do {
            if isSaved {
                let persistenceGroupSessionEvents = try self.groupSessionEventsPersistenceManager.getSessionEventsByGroupId(group.groupId)

                if persistenceGroupSessionEvents != nil {
                    DispatchQueue.main.async {
                        completionHandler(
                            .success(GroupSessionEventsFetchResult(sessionEvents: persistenceGroupSessionEvents, loadedWithChanges: false))
                        )
                    }
                }
            }
        } catch let error {
            DispatchQueue.main.async { completionHandler(.failure(error)) }
        }
    }

    func fetchSessionEvents(
        group: AcademicGroupDTO,
        isOnline: Bool,
        isSaved: Bool,
        completionHandler: @escaping (Result<GroupSessionEventsFetchResult, Error>) -> Void
    ) {
        do {
            if isSaved {
                let persistenceGroupSessionEvents = try self.groupSessionEventsPersistenceManager.getSessionEventsByGroupId(group.groupId)
                if isOnline {
                    self.sessionEventsNetworkManager.getGroupSessionEvents(
                        group: group,
                        resultQueue: DispatchQueue.main
                    ) { result in
                        switch result {
                        case .success(let networkGroupSessionEvents):
                            do {
                                if persistenceGroupSessionEvents == nil || Set(networkGroupSessionEvents.sessionEvents) != Set(persistenceGroupSessionEvents!.sessionEvents) {
                                    DispatchQueue.main.async {
                                        let loadedSessionEventsWithChanges = persistenceGroupSessionEvents != nil && Set(networkGroupSessionEvents.sessionEvents) != Set(persistenceGroupSessionEvents!.sessionEvents)
                                        completionHandler(
                                            .success(GroupSessionEventsFetchResult(sessionEvents: networkGroupSessionEvents, loadedWithChanges: loadedSessionEventsWithChanges))
                                        )
                                    }

                                    try saveGroupSessionEventsWithDeletingPreviousVersion(groupSessionEvents: networkGroupSessionEvents)
                                } else {
                                    DispatchQueue.main.async {
                                        completionHandler(
                                            .success(GroupSessionEventsFetchResult(sessionEvents: persistenceGroupSessionEvents, loadedWithChanges: false))
                                        )
                                    }
                                }
                            } catch {
                                DispatchQueue.main.async { completionHandler(.failure(error)) }
                            }

                        case .failure(let error):
                            DispatchQueue.main.async { completionHandler(.failure(error)) }
                        }
                    }
                }

            } else if isOnline {
                sessionEventsNetworkManager.getGroupSessionEvents(
                    group: group,
                    resultQueue: .main
                ) { result in
                    switch result {
                    case .success(let sessionEvents):
                        DispatchQueue.main.async {
                            completionHandler(
                                .success(GroupSessionEventsFetchResult(sessionEvents: sessionEvents, loadedWithChanges: false))
                            )
                        }
                    case .failure(let error):
                        DispatchQueue.main.async { completionHandler(.failure(error)) }
                    }
                }
            }
        } catch let error {
            DispatchQueue.main.async { completionHandler(.failure(error)) }
        }
    }

    private func saveGroupSessionEventsWithDeletingPreviousVersion(groupSessionEvents: GroupSessionEventsDTO) throws {
        try self.groupSessionEventsPersistenceManager.deleteSessionEventsByGroupId(groupSessionEvents.group.groupId)
        try self.groupSessionEventsPersistenceManager.saveItem(groupSessionEvents)
    }
}
