//
//  SGU_ScheduleApp.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI

@main
struct SGU_ScheduleApp: App {

    @State var widgetUrl: String?
    let favouriteGroupNumber = UserDefaults.standard.string(forKey: UserDefaultsKeys.favoriteGroupNumberKey.rawValue)
    let appSettings = AppSettings()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(
                    ViewsManager(
                        appSettings: appSettings,
                        viewModelFactory: ViewModelWithParsingSGUFactory(),
                        viewModelFactory_old: ViewModelWithParsingSGUFactory_old(),
                        groupSchedulePersistenceManager: GroupScheduleCoreDataManager(),
                        groupSessionEventsPersistenceManager: GroupSessionEventsCoreDataManager(),
                        groupPersistenceManager: GroupCoreDataManager(),
                        widgetUrl: widgetUrl
                    )

                )
                .environmentObject(NetworkMonitor())
                .environmentObject(appSettings)
                .onOpenURL { url in
                    widgetUrl = url.absoluteString
                }
        }
    }
}
