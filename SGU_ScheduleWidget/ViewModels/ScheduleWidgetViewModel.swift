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
    
    @Published var fetchResult = ScheduleFetchResult(resultVariant: .UnknownErrorWhileFetching)
    
    init(schedulePersistenceManager: GroupSchedulePersistenceManager) {
        self.schedulePersistenceManager = schedulePersistenceManager
    }
    
    public func fetchSavedSchedule() {
        do {
            let schedule = try self.schedulePersistenceManager.getFavouriteGroupScheduleDTO()
            if schedule == nil {
                fetchResult = ScheduleFetchResult(resultVariant: .NoFavoriteGroup)
            } else {
                let (currentEvent, nextLesson, _) = schedule?.getCurrentAndNextLessons() ?? (nil, nil, nil)
                let closeLesson = schedule?.getFirstCloseToNowLesson()
                fetchResult = ScheduleFetchResult(
                    resultVariant: .Success,
                    currentEvent: currentEvent,
                    nextLesson: nextLesson,
                    closeLesson: closeLesson
                )
            }
        }
        catch {
            fetchResult = ScheduleFetchResult(resultVariant: .UnknownErrorWhileFetching)
        }
    }
}
