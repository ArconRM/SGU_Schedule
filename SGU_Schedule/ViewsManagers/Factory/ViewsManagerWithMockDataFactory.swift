//
//  ViewsManagerWithMockDataFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation

final class ViewsManagerWithMockDataFactory {
    func makeViewsManager() -> ViewsManager {
        return ViewsManager(
            appSettings: AppSettings(),
            viewModelFactory: ViewModelWithMockDataFactory(),
            viewModelFactory_old: ViewModelWithMockDataFactory(),
            groupSchedulePersistenceManager: GroupSchedulePersistenceManagerMock(),
            groupSessionEventsPersistenceManager: GroupSessionEventsPersistenceManagerMock(),
            groupPersistenceManager: GroupPersistenceManagerMock(),
            widgetUrl: ""
        )
    }
}
