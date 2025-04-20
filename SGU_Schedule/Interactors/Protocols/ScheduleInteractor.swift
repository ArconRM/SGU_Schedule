//
//  ScheduleInteractor.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 17.04.2025.
//

import Foundation

protocol ScheduleInteractor {
    func fetchSavedSchedule(
        group: AcademicGroupDTO,
        isSaved: Bool,
        completionHandler: @escaping (Result<GroupScheduleFetchResult, Error>) -> Void
    )

    func fetchSchedule(
        group: AcademicGroupDTO,
        isOnline: Bool,
        isSaved: Bool,
        isFavourite: Bool,
        completionHandler: @escaping (Result<GroupScheduleFetchResult, Error>) -> Void
    )

    func fetchSubgroupsByLessons(schedule: GroupScheduleDTO) -> [String: [LessonSubgroupDTO]]

    func saveSubgroup(
        groupSchedule: GroupScheduleDTO,
        subgroupsByLessons: [String: [LessonSubgroupDTO]],
        lesson: String,
        subgroup: LessonSubgroupDTO
    ) throws -> [String: [LessonSubgroupDTO]]

    func clearSubgroups()

    func fetchSavedSessionEvents(
        group: AcademicGroupDTO,
        isSaved: Bool,
        completionHandler: @escaping (Result<GroupSessionEventsFetchResult, Error>) -> Void
    )

    func fetchSessionEvents(
        group: AcademicGroupDTO,
        isOnline: Bool,
        isSaved: Bool,
        completionHandler: @escaping (Result<GroupSessionEventsFetchResult, Error>) -> Void
    )
}
