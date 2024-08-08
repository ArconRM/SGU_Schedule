//
//  SGU_ScheduleApp.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI

@main
struct SGU_ScheduleApp: App {
    
    let appSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(NetworkMonitor())
                .environmentObject(ViewsManager(viewModelFactory: ViewModelWithParsingSGUFactory(), schedulePersistenceManager: GroupScheduleCoreDataManager()))
                .environmentObject(appSettings)
        }
    }
}
