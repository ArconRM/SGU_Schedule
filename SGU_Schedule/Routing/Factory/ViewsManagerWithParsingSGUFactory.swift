//
//  ViewsManagerWithParsingSGUFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation

final class ViewsManagerWithParsingSGUFactory {
    func makeViewsManager(
        appearanceSettings: AppearanceSettingsStore,
        persistentUserSettings: PersistentUserSettingsStore,
        routingState: RoutingState,
        notificationManager: NotificationManager,
        widgetUrl: String?
    ) -> ViewsManager {
        return ViewsManager(
            appearanceSettings: appearanceSettings,
            persistentUserSettings: persistentUserSettings,
            routingState: routingState,
            viewModelFactory: ViewModelWithParsingSGUFactory(),
            groupSchedulePersistenceManager: GroupScheduleCoreDataManager(),
            groupSessionEventsPersistenceManager: GroupSessionEventsCoreDataManager(),
            groupPersistenceManager: GroupCoreDataManager(),
            notificationManager: notificationManager,
            widgetUrl: widgetUrl
        )
    }
}
