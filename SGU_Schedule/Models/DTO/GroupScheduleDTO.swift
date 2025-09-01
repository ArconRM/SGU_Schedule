//
//  GroupScheduleDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 03.11.2023.
//

import Foundation

// TODO: Многовато говна
struct GroupScheduleDTO: Equatable {

    var group: AcademicGroupDTO
    var lessons: [LessonDTO]
    var lastUpdated: String

    init(groupNumber: String, departmentCode: String, lessonsByDays: [LessonDTO], lastUpdated: String) {
        self.group = AcademicGroupDTO(fullNumber: groupNumber, departmentCode: departmentCode)
        self.lessons = lessonsByDays
        self.lastUpdated = lastUpdated
    }

    static var mock: Self {
        .init(
            groupNumber: AcademicGroupDTO.mock.fullNumber,
            departmentCode: AcademicGroupDTO.mock.departmentCode,
            lessonsByDays: LessonDTO.mocks,
            lastUpdated: "Never"
        )
    }

    // Мб адекватнее можно сделать
    var lessonsAndWindows: [any ScheduleEvent] {
        var result: [any ScheduleEvent] = lessons

        for weekday in Weekdays.allCases {
            guard let firstLesson = getFirstLessonByDay(subgroupsByLessons: [:], weekDayNumber: weekday.number) else {
                continue
            }

            var lastSeenLesson = firstLesson
            for lessonNumber in (firstLesson.lessonNumber + 1)...7 {
                let lessonsByDayAndNumber = self.lessons.filter { $0.weekDay == weekday && $0.lessonNumber == lessonNumber }

                if !lessonsByDayAndNumber.isEmpty {
                    if lessonNumber - lastSeenLesson.lessonNumber > 1 {
                        let window = TimeBreakDTO(
                            weekDay: lastSeenLesson.weekDay,
                            lessonNumber: lessonNumber - 1,
                            timeStart: lastSeenLesson.timeEnd,
                            timeEnd: lessonsByDayAndNumber.first!.timeStart,
                            isWindow: true
                        )
                        result.append(window)
                    }

                    lastSeenLesson = lessonsByDayAndNumber.first!
                }
            }
        }

        return result
    }

    func getFirstLessonByDay(subgroupsByLessons: [String: [LessonSubgroupDTO]], weekDayNumber: Int) -> LessonDTO? {
        let todayLessons = self.lessons.filter { $0.weekDay.number == weekDayNumber && $0.isActive(subgroupsByLessons: subgroupsByLessons) }
        guard !todayLessons.isEmpty else { return nil }

        for lessonNumber in 1...8 {
            let todayLessonsByNumber = todayLessons.filter { $0.lessonNumber == lessonNumber }
            if todayLessonsByNumber.isEmpty {
                continue
            }
            return todayLessonsByNumber.first
        }

        return nil
    }

    func getTodayFirstLesson(subgroupsByLessons: [String: [LessonSubgroupDTO]]) -> LessonDTO? {
        let currentWeekDayNumber = Date.currentWeekday.number

        return getFirstLessonByDay(subgroupsByLessons: subgroupsByLessons, weekDayNumber: currentWeekDayNumber)
    }

    func getCurrentAndNextLessons(subgroupsByLessons: [String: [LessonSubgroupDTO]]) -> (
        currentEvent: (any ScheduleEvent)?,
        nextLesson1: LessonDTO?,
        nextLesson2: LessonDTO?
    ) {
        // Проверяем есть ли вообще занятия
        let currentWeekDayNumber = Date.currentWeekday.number
        let currentTime = Date.currentHoursAndMinutes

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
            if Date.checkIfTimeIsBetweenTwoTimes(
                dateStart: todayLessonsByNumber[0].timeStart,
                dateMiddle: currentTime,
                dateEnd: todayLessonsByNumber[0].timeEnd
            ) {
                var currentLesson = todayLessonsByNumber[0]
                if todayLessonsByNumber.count > 1 { // Значит есть подгруппы и общего кабинета нет
                    currentLesson.cabinet = "По подгруппам"
                }
                return (
                    currentLesson,
                    getNextTwoLessons(lessons: todayLessons, from: lessonNumber).0,
                    getNextTwoLessons(lessons: todayLessons, from: lessonNumber).1
                )

                // Ищем перемену
            } else if lessonNumber != 8 { // Смотрим следующую пару, когда находим - выходим
                for nextLessonNumber in (lessonNumber + 1)...8 {
                    let todayLessonsByNumberNext = todayLessons.filter { $0.lessonNumber == nextLessonNumber }
                    if todayLessonsByNumberNext.isEmpty {
                        continue
                    }

                    if Date.checkIfTimeIsBetweenTwoTimes(
                        dateStart: todayLessonsByNumber[0].timeEnd,
                        dateMiddle: currentTime,
                        dateEnd: todayLessonsByNumberNext[0].timeStart,
                        strictInequality: true
                    ) {
                        let currentTimeBreak = TimeBreakDTO(
                            weekDay: Weekdays(dayNumber: currentWeekDayNumber)!,
                            lessonNumber: lessonNumber,
                            timeStart: todayLessonsByNumber[0].timeEnd,
                            timeEnd: todayLessonsByNumberNext[0].timeStart,
                            isWindow: nextLessonNumber - lessonNumber > 1
                        )
                        return (
                            currentTimeBreak,
                            getNextTwoLessons(lessons: todayLessons, from: lessonNumber).0,
                            getNextTwoLessons(lessons: todayLessons, from: lessonNumber).1
                        )
                    }

                    break
                }
            }
        }

        return (nil, nil, nil)
    }

    /// If possible, sets twoNextLessons to two nearest lessons from given array, which have greater lessonNumber than given one
    private func getNextTwoLessons(
        lessons: [LessonDTO],
        from number: Int
    ) -> (LessonDTO?, LessonDTO?) {
        var nextLesson1: LessonDTO?
        var nextLesson2: LessonDTO?

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

    func getSubgroupsByLessons(savedSubgroups: [String: LessonSubgroupDTO]) -> [String: [LessonSubgroupDTO]] {
        var subgroupsByLessons: [String: [LessonSubgroupDTO]] = [:]
        for lesson in self.lessons {
            if lesson.subgroup != nil && !lesson.subgroup!.isEmpty && lesson.subgroup!.contains(where: { $0.isNumber }) {
                let isSaved = savedSubgroups[lesson.title] != nil && savedSubgroups[lesson.title]?.number == lesson.subgroup
                if subgroupsByLessons[lesson.title] != nil && !subgroupsByLessons[lesson.title]!.contains(where: { $0.number == lesson.subgroup }) {
                    subgroupsByLessons[lesson.title]!.append(LessonSubgroupDTO(teacher: lesson.teacherFullName, number: lesson.subgroup!, isSaved: isSaved))
                } else {
                    subgroupsByLessons[lesson.title] = [LessonSubgroupDTO(teacher: lesson.teacherFullName, number: lesson.subgroup!, isSaved: isSaved)]
                }
            }
        }
        return subgroupsByLessons.filter({ $0.value.count > 1 }).mapValues({ $0.sorted(by: { $0.displayNumber < $1.displayNumber })})
    }

    func getUniqueLessonsTitles() -> [String] {
        var result: [String] = []
        for lesson in self.lessons where !result.contains(lesson.title) {
            result.append(lesson.title)
        }
        return result
    }
}
