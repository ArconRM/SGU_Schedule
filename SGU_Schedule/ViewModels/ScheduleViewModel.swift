//
//  ScheduleViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 07.10.2023.
//

import Foundation
import WidgetKit
import ActivityKit

// Че то он ебать огромным выходит + многовато говна
class ScheduleViewModel: BaseViewModel {
    private let lessonsNetworkManager: LessonNetworkManager
    private let sessionEventsNetworkManager: SessionEventsNetworkManager

    private let groupSchedulePersistenceManager: GroupSchedulePersistenceManager
    private let lessonSubgroupsPersistenceManager: LessonSubgroupsPersistenceManager
    private let groupSessionEventsPersistenceManager: GroupSessionEventsPersistenceManager

    @Published var groupSchedule: GroupScheduleDTO?
    @Published var groupSessionEvents: GroupSessionEventsDTO?
    @Published var subgroupsByLessons: [String: [LessonSubgroupDTO]] = [:]

    @Published var savedSubgroupsCount = 0

    @Published var scheduleEventsBySelectedDay = [any ScheduleEvent]()
    @Published var selectedDay: Weekdays = Date.currentWeekDayWithoutSundayAndWithEveningBeingNextDay

    @Published var currentEvent: (any ScheduleEvent)?
    @Published var nextLesson1: LessonDTO?
    @Published var nextLesson2: LessonDTO?

    @Published var isLoadingLessons = true
    @Published var loadedLessonsWithChanges = false
    @Published var isLoadingSessionEvents = true
    @Published var loadedSessionEventsWithChanges = false

    @Published var currentActivities: [Activity<ScheduleEventAttributes>]

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

        currentActivities = Activity<ScheduleEventAttributes>.activities
    }

    func updateScheduleEventsBySelectedDay() {
        if groupSchedule != nil {
            scheduleEventsBySelectedDay = groupSchedule!.lessonsAndWindows.filter { $0.weekDay == selectedDay }
        }
    }

    /// Возвращает пары по номеру в выбранный день недели + окна между ними если таковые имеются
    func getScheduleEventsBySelectedDayAndNumber(lessonNumber: Int) -> [any ScheduleEvent] {
        let scheduleEventsByNumber = scheduleEventsBySelectedDay.filter({ $0.lessonNumber == lessonNumber })
        return scheduleEventsByNumber
    }

    func getScheduleEventsBySelectedDayAndNumberFilteredBySubgroups(lessonNumber: Int) -> [any ScheduleEvent] {
        let scheduleEventsByNumber = scheduleEventsBySelectedDay.filter({ $0.lessonNumber == lessonNumber })
        return scheduleEventsByNumber.filter({
            if let lesson = $0 as? LessonDTO {
                return lesson.isActive(subgroupsByLessons: subgroupsByLessons)
            }
            return true
        })
    }

    /// Если группа сохранена и в онлайне - получает расписание с networkManager.
    /// Если группа сохранена и сохраненное расписание различается с оным с networkManager - перезаписывает его.
    /// В иных случаях просто ставит расписание с networkManager.
    func fetchSchedule(group: AcademicGroupDTO, isOnline: Bool, isSaved: Bool, isFavourite: Bool) {
        currentEvent = nil
        nextLesson1 = nil
        nextLesson2 = nil

        isLoadingLessons = true

        do {
            // Если сохраненная группа
            if isSaved {
                let persistenceSchedule = try self.groupSchedulePersistenceManager.getScheduleByGroupId(group.groupId)

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
                    self.lessonsNetworkManager.getGroupScheduleForCurrentWeek(
                        group: group,
                        resultQueue: DispatchQueue.main
                    ) { result in
                        switch result {
                        case .success(let networkSchedule):
                            do {
                                if persistenceSchedule == nil || Set(networkSchedule.lessons) != Set(persistenceSchedule!.lessons) {
                                    self.groupSchedule = networkSchedule
                                    try self.saveNewScheduleWithDeletingPreviousVersion(schedule: networkSchedule)

                                    if isFavourite {
                                        self.fetchSubgroups()
                                    }
                                    self.setCurrentAndTwoNextLessons()

                                    self.loadedLessonsWithChanges = persistenceSchedule != nil && Set(networkSchedule.lessons) != Set(persistenceSchedule!.lessons)

                                } else {
                                    self.groupSchedule = persistenceSchedule
                                }

                                self.isLoadingLessons = false
                            } catch let error {
                                self.showCoreDataError(error)
                            }

                        case .failure(let error):
                            self.showNetworkError(error)
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
                        self.groupSchedule = schedule
                        self.setCurrentAndTwoNextLessons()

                    case .failure(let error):
                        self.showNetworkError(error)
                    }

                    self.isLoadingLessons = false
                }
            }

            WidgetCenter.shared.reloadAllTimelines()
        } catch let error {
            self.showCoreDataError(error)
        }
    }

    private func saveNewScheduleWithDeletingPreviousVersion(schedule: GroupScheduleDTO) throws {
        try self.groupSchedulePersistenceManager.deleteScheduleByGroupId(schedule.group.groupId)
        try self.groupSchedulePersistenceManager.saveItem(schedule)
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

    private func fetchSubgroups() {
        if groupSchedule != nil {
            let savedSubgroups = lessonSubgroupsPersistenceManager.getSavedSubgroups(lessonsInSchedule: groupSchedule!.getUniqueLessonsTitles())
            savedSubgroupsCount = savedSubgroups.count
            self.subgroupsByLessons = groupSchedule!.getSubgroupsByLessons(savedSubgroups: savedSubgroups)
        }
    }

    func saveSubgroup(lesson: String, subgroup: LessonSubgroupDTO) {
        if self.subgroupsByLessons[lesson] != nil {
            for subgroupIndex in subgroupsByLessons[lesson]!.indices {
                subgroupsByLessons[lesson]?[subgroupIndex].isSaved = subgroupsByLessons[lesson]?[subgroupIndex] == subgroup
            }

            do {
                try lessonSubgroupsPersistenceManager.saveItem(lesson: lesson, item: subgroup)
                let savedSubgroups = lessonSubgroupsPersistenceManager.getSavedSubgroups(lessonsInSchedule: groupSchedule!.getUniqueLessonsTitles())
                savedSubgroupsCount = savedSubgroups.count
            } catch {
                showUDError(error)
            }
        }
    }

    func clearSubgroups() {
        lessonSubgroupsPersistenceManager.clearSaved()
        fetchSubgroups()
    }

    /// Если группа сохранена и в онлайне - получает раписание сессии с networkManager.
    /// Если группа сохранена и расписание сессии с бд различается с оным с networkManager - перезаписывает его.
    /// В иных случаях просто ставит расписание с networkManager.
    func fetchSessionEvents(group: AcademicGroupDTO, isOnline: Bool, isSaved: Bool) {
        isLoadingSessionEvents = true

        do {
            if isSaved {
                let persistenceGroupSessionEvents = try self.groupSessionEventsPersistenceManager.getSessionEventsByGroupId(group.groupId)

                if persistenceGroupSessionEvents != nil {
                    self.groupSessionEvents = persistenceGroupSessionEvents
                }

                if isOnline {
                    self.sessionEventsNetworkManager.getGroupSessionEvents(
                        group: group,
                        resultQueue: DispatchQueue.main
                    ) { result in
                        switch result {
                        case .success(let networkGroupSessionEvents):
                            do {
                                if persistenceGroupSessionEvents == nil || Set(networkGroupSessionEvents.sessionEvents) != Set(persistenceGroupSessionEvents!.sessionEvents) {
                                    self.groupSessionEvents = networkGroupSessionEvents
                                    try self.saveGroupSessionEventsWithDeletingPreviousVersion(groupSessionEvents: networkGroupSessionEvents)

                                    self.loadedSessionEventsWithChanges = persistenceGroupSessionEvents != nil && Set(networkGroupSessionEvents.sessionEvents) != Set(persistenceGroupSessionEvents!.sessionEvents)
                                } else {
                                    self.groupSessionEvents = persistenceGroupSessionEvents
                                }

                                self.isLoadingSessionEvents = false
                            } catch {
                                self.showCoreDataError(error)
                            }

                        case .failure(let error):
                            self.showNetworkError(error)
                        }
                    }
                }

            } else if isOnline {
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

            WidgetCenter.shared.reloadAllTimelines()
        } catch let error {
            self.showCoreDataError(error)
        }
    }

    private func saveGroupSessionEventsWithDeletingPreviousVersion(groupSessionEvents: GroupSessionEventsDTO) throws {
        try self.groupSessionEventsPersistenceManager.deleteSessionEventsByGroupId(groupSessionEvents.group.groupId)
        try self.groupSessionEventsPersistenceManager.saveItem(groupSessionEvents)
    }
}

extension ScheduleViewModel {
    func startAllTodaysActivitiesByLessonNumber(lessonNumber: Int) {
        let scheduleEvents = getScheduleEventsBySelectedDayAndNumberFilteredBySubgroups(lessonNumber: lessonNumber)
        let lessons = scheduleEvents.filter({ ($0 as? LessonDTO) != nil }) as! [LessonDTO]
        for lesson in lessons {
            startActivity(lesson: lesson)
        }
    }

    func startActivity(lesson: LessonDTO) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let attributes = ScheduleEventAttributes()
        let state = ScheduleEventAttributes.ContentState(
            lessonTitle: lesson.title,
            teacherFullName: lesson.teacherFullName,
            lessonType: lesson.lessonType,
            cabinet: lesson.cabinet,
            timeStart: lesson.timeStart,
            timeEnd: lesson.timeEnd
        )

        if let activity = try? Activity<ScheduleEventAttributes>.request(attributes: attributes, content: ActivityContent(state: state, staleDate: nil)) {
            currentActivities.append(activity)

            let dismissalPolicy = ActivityUIDismissalPolicy.after(lesson.timeEnd.toTodayDate())
            Task {
                await activity.end(nil, dismissalPolicy: dismissalPolicy)
            }
        }
    }

    func endAllActivities() {
        for activity in currentActivities {
            Task {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
        self.currentActivities = []
    }

//    func endActivity() {
//        Task {
//            await currentActivity?.end(nil, dismissalPolicy: .immediate)
//            await MainActor.run {
//                self.currentActivity = nil
//            }
//        }
//    }
}
