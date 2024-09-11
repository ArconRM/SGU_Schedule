//
//  SGU_ScheduleApp.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI

@main
struct SGU_ScheduleApp: App {
    
    @State var isOpenedFromWidget: Bool = false
    let appSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(
                    ViewsManager(
                        viewModelFactory: ViewModelWithParsingSGUFactory(),
                        viewModelFactory_old: ViewModelWithParsingSGUFactory_old(),
                        schedulePersistenceManager: GroupScheduleCoreDataManager(),
                        groupPersistenceManager: GroupCoreDataManager(), 
                        isOpenedFromWidget: isOpenedFromWidget
                    )
                )
                .environmentObject(NetworkMonitor())
                .environmentObject(appSettings)
                .onOpenURL { url in
                    if url.absoluteString == AppUrls.OpenedFromWidget.rawValue {
                        isOpenedFromWidget = true
                    }
                }
        }
    }
}
