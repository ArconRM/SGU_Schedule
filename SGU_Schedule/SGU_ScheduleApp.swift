//
//  SGU_ScheduleApp.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI

@main
struct SGU_ScheduleApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(groupsViewModel: GroupsViewModelWithParsingSGU())
                .environmentObject(NetworkMonitor())
                .environmentObject(ViewsManager())
        }
    }
}
