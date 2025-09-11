//
//  SessionEventsWidgetViewModel.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 08.01.2025.
//

import Foundation

public final class SessionEventsWidgetViewModel: ObservableObject {

    private let sessionEventsPersistenceManager: GroupSessionEventsPersistenceManager

    @Published var fetchResult: SessionEventsFetchResult = .unknownErrorWhileFetching()

    init(sessionEventsPersistenceManager: GroupSessionEventsPersistenceManager) {
        self.sessionEventsPersistenceManager = sessionEventsPersistenceManager
    }

    public func fetchSavedSessionEvents() {
        do {
            let sessionEvents = try sessionEventsPersistenceManager.getFavouriteGroupSessionEventsDTO()
            if sessionEvents == nil {
                fetchResult = .noFavoriteGroup
            } else {
                let (consultation, exam) = sessionEvents!.getNextConsultationAndExam()

                fetchResult = .success(consultation: consultation, exam: exam)
            }
        } catch let error {
            fetchResult = .unknownErrorWhileFetching(error: error)
        }
    }
}
