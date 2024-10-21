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
    private let lessonSubgroupsPersistenceManager: LessonSubgroupsPersistenceManager
    
    @Published var fetchResult = ScheduleFetchResultForWidget(resultVariant: .UnknownErrorWhileFetching)
    
    init(schedulePersistenceManager: GroupSchedulePersistenceManager,
         lessonSubgroupsPersistenceManager: LessonSubgroupsPersistenceManager) {
        self.schedulePersistenceManager = schedulePersistenceManager
        self.lessonSubgroupsPersistenceManager = lessonSubgroupsPersistenceManager
    }
    
    public func fetchSavedSchedule() {
        do {
            let schedule = try self.schedulePersistenceManager.getFavouriteGroupScheduleDTO()
            if schedule == nil {
                fetchResult = ScheduleFetchResultForWidget(resultVariant: .NoFavoriteGroup)
            } else {
                let subgroupsByLessons = schedule!.getSubgroupsByLessons(savedSubgroups: lessonSubgroupsPersistenceManager.getSavedSubgroups())
                
                let firstLesson = schedule!.getTodayFirstLesson(subgroupsByLessons: subgroupsByLessons)
                let (currentEvent, nextLesson, _) = schedule!.getCurrentAndNextLessons(subgroupsByLessons: subgroupsByLessons)
                
                fetchResult = ScheduleFetchResultForWidget(
                    resultVariant: .Success,
                    firstLesson: firstLesson,
                    currentEvent: currentEvent,
                    nextLesson: nextLesson
                )
            }
        }
        catch {
            fetchResult = ScheduleFetchResultForWidget(resultVariant: .UnknownErrorWhileFetching)
        }
    }
}
