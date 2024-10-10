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
    
    @Published var fetchResult = ScheduleFetchResultForWidget(resultVariant: .UnknownErrorWhileFetching)
    
    init(schedulePersistenceManager: GroupSchedulePersistenceManager) {
        self.schedulePersistenceManager = schedulePersistenceManager
    }
    
    public func fetchSavedSchedule() {
        do {
            let schedule = try self.schedulePersistenceManager.getFavouriteGroupScheduleDTO()
            if schedule == nil {
                fetchResult = ScheduleFetchResultForWidget(resultVariant: .NoFavoriteGroup)
            } else {
                let firstLesson = schedule!.getTodayFirstLesson()
                let (currentEvent, nextLesson, _) = schedule!.getCurrentAndNextLessons()
                
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
