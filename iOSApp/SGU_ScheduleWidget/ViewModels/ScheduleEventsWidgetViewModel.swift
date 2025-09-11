//
//  SGU_ScheduleWidgetViewModel.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 03.08.2024.
//

import Foundation

public final class ScheduleEventsWidgetViewModel: ObservableObject {

    private let schedulePersistenceManager: GroupSchedulePersistenceManager
    private let lessonSubgroupsPersistenceManager: LessonSubgroupsPersistenceManager

    @Published var fetchResult = ScheduleEventsFetchResult.unknownErrorWhileFetching()

    init(
        schedulePersistenceManager: GroupSchedulePersistenceManager,
        lessonSubgroupsPersistenceManager: LessonSubgroupsPersistenceManager
    ) {
        self.schedulePersistenceManager = schedulePersistenceManager
        self.lessonSubgroupsPersistenceManager = lessonSubgroupsPersistenceManager
    }

    public func fetchSavedSchedule() {
        do {
            let schedule = try schedulePersistenceManager.getFavouriteGroupScheduleDTO()
            if schedule == nil {
                fetchResult = .noFavoriteGroup
            } else {
                let subgroupsByLessons = schedule!.getSubgroupsByLessons(savedSubgroups: lessonSubgroupsPersistenceManager.getSavedSubgroups())

                let firstLesson = schedule!.getTodayFirstLesson(subgroupsByLessons: subgroupsByLessons)
                let (currentEvent, nextLesson, _) = schedule!.getCurrentAndNextLessons(subgroupsByLessons: subgroupsByLessons)

                fetchResult = .success(
                    currentEvent: currentEvent,
                    firstLesson: firstLesson,
                    nextLesson: nextLesson
                )
            }
        } catch let error {
            fetchResult = .unknownErrorWhileFetching(error: error)
        }
    }
}
