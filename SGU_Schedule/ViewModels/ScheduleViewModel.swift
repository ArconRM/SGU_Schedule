//
//  ScheduleViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 07.10.2023.
//

import Foundation
import WidgetKit
import ActivityKit

class ScheduleViewModel: BaseViewModel {
    private let scheduleInteractor: ScheduleInteractor

    @Published var groupSchedule: GroupScheduleDTO?
    @Published var groupSessionEvents: GroupSessionEventsDTO?

    @Published var subgroupsByLessons: [String: [LessonSubgroupDTO]] = [:]

    @Published var selectedDay: Weekdays = Date.currentWeekDayWithoutSundayAndWithEveningBeingNextDay
    var scheduleEventsBySelectedDay: [any ScheduleEvent] {
        groupSchedule?.lessonsAndWindows.filter { $0.weekDay == selectedDay } ?? []
    }
    var scheduleEventsByCurrentDay: [any ScheduleEvent] {
        groupSchedule?.lessonsAndWindows.filter { $0.weekDay == Date.currentWeekday } ?? []
    }

    @Published var currentEvent: (any ScheduleEvent)?
    @Published var nextLesson1: LessonDTO?
    @Published var nextLesson2: LessonDTO?

    @Published var isLoadingLessons = true
    @Published var loadedLessonsWithChanges = false
    @Published var isLoadingSessionEvents = true
    @Published var loadedSessionEventsWithChanges = false

    @Published var currentActivities: [Activity<ScheduleEventAttributes>]

    init(scheduleInteractor: ScheduleInteractor) {
        self.scheduleInteractor = scheduleInteractor
        currentActivities = Activity<ScheduleEventAttributes>.activities
    }

    /// Возвращает пары по номеру в выбранный день недели + окна между ними если таковые имеются
    func getScheduleEventsBySelectedDayAndNumber(lessonNumber: Int) -> [any ScheduleEvent] {
        let scheduleEventsByNumber = scheduleEventsBySelectedDay.filter({ $0.lessonNumber == lessonNumber })
        return scheduleEventsByNumber
    }

    /// Возвращает еще не закончившиеся пары в текущий день + окна между ними если таковые имеются
    func getFutureScheduleEventsByCurrentDayFilteredBySubgroups() -> [any ScheduleEvent] {
        let scheduleEventsByNumber = scheduleEventsByCurrentDay.filter(
            {
                Date.compareDatesByTime(
                    date1: $0.timeEnd,
                    date2: Date.currentHoursAndMinutes,
                    strictInequality: false
                )
            })
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

        scheduleInteractor.fetchSavedSchedule(
            group: group,
            isSaved: isSaved
        ) { result in
            switch result {
            case .success(let fetchResult):
                self.groupSchedule = fetchResult.groupSchedule
            case .failure(let error):
                self.showError(error)
            }
        }

        scheduleInteractor.fetchSchedule(
            group: group,
            isOnline: isOnline,
            isSaved: isSaved,
            isFavourite: isFavourite
        ) { result in
            switch result {
            case .success(let fetchResult):
                self.groupSchedule = fetchResult.groupSchedule
                self.loadedLessonsWithChanges = fetchResult.loadedWithChanges
                self.isLoadingLessons = false

                if let groupSchedule = self.groupSchedule {
                    self.setCurrentAndTwoNextLessons()
                    if isFavourite {
                        self.subgroupsByLessons = self.scheduleInteractor.fetchSubgroupsByLessons(schedule: groupSchedule)
                    }
                }

                WidgetCenter.shared.reloadAllTimelines()

            case .failure(let error):
                self.showError(error)
            }
        }
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

    func saveSubgroup(lesson: String, subgroup: LessonSubgroupDTO) {
        if let groupSchedule = groupSchedule {
            do {
                subgroupsByLessons = try scheduleInteractor.saveSubgroup(
                    groupSchedule: groupSchedule,
                    subgroupsByLessons: subgroupsByLessons,
                    lesson: lesson,
                    subgroup: subgroup
                )
            } catch let error {
                showError(error)
            }
        }
    }

    func clearSubgroups() {
        scheduleInteractor.clearSubgroups()
        if let groupSchedule = groupSchedule {
            subgroupsByLessons = scheduleInteractor.fetchSubgroupsByLessons(schedule: groupSchedule)
        }
    }

    /// Если группа сохранена и в онлайне - получает раписание сессии с networkManager.
    /// Если группа сохранена и расписание сессии с бд различается с оным с networkManager - перезаписывает его.
    /// В иных случаях просто ставит расписание с networkManager.
    func fetchSessionEvents(group: AcademicGroupDTO, isOnline: Bool, isSaved: Bool) {
        isLoadingSessionEvents = true

        scheduleInteractor.fetchSavedSessionEvents(
            group: group,
            isSaved: isOnline
        ) { result in
            switch result {
            case .success(let fetchResult):
                self.groupSessionEvents = fetchResult.sessionEvents
            case .failure(let error):
                self.showError(error)
            }
        }

        scheduleInteractor.fetchSessionEvents(
            group: group,
            isOnline: isOnline,
            isSaved: isSaved
        ) { result in
            switch result {
            case .success(let fetchResult):
                self.groupSessionEvents = fetchResult.sessionEvents
                self.loadedSessionEventsWithChanges = fetchResult.loadedWithChanges

                self.isLoadingSessionEvents = false

                WidgetCenter.shared.reloadAllTimelines()

            case .failure(let error):
                self.showError(error)
            }
        }
    }
}

extension ScheduleViewModel {
    func startAllTodaysActivitiesByLessonNumber() {
        let scheduleEvents = getFutureScheduleEventsByCurrentDayFilteredBySubgroups()
        let lessons = scheduleEvents.filter({ ($0 as? LessonDTO) != nil }) as? [LessonDTO] ?? []
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
}
