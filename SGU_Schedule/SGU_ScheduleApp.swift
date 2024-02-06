//
//  SGU_ScheduleApp.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI

@main
struct SGU_ScheduleApp: App {
    
//    let groupsViewModel = GroupsViewModelWithParsingSGU(networkManager: GroupsNetworkManagerWithParsing(urlSource: URLSourceSGU(), groupsParser: GroupsHTMLParserSGU()))
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(NetworkMonitor())
                .environmentObject(ViewsManager())
        }
    }
}
