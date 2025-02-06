//
//  ViewsManagerWithParsingSGUFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation

final class ViewsManagerWithParsingSGUFactory {
    func makeViewsManager(appSettings: AppSettings, widgetUrl: String?) -> ViewsManager {
        return ViewsManager(
            appSettings: appSettings,
            viewModelFactory: ViewModelWithParsingSGUFactory(),
            viewModelFactory_old: ViewModelWithParsingSGUFactory_old(),
            groupSchedulePersistenceManager: GroupScheduleCoreDataManager(),
            groupSessionEventsPersistenceManager: GroupSessionEventsCoreDataManager(),
            groupPersistenceManager: GroupCoreDataManager(),
            widgetUrl: widgetUrl
        )
    }
}
