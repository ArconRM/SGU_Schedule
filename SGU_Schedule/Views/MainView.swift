//
//  MainView.swift
//  SGU_Schedule
//
//  Created by Артемий on 01.02.2024.
//

import SwiftUI

//TODO: мб все таки через интерфейсы как-то, пока для теста нужно создавать отдельную mainview
struct MainView: View {
    
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    
    var groupsViewModel = GroupsViewModelWithParsingSGUAssembly().build()
    let scheduleViewModelAssembly = ScheduleViewModelWithParsingSGUAssembly()
    
    var body: some View {
        VStack {
            switch viewsManager.currentView {
            case .GroupsView:
                GroupsView(viewModel: groupsViewModel)
                    .environmentObject(networkMonitor)
                    .environmentObject(viewsManager)
            case .ScheduleView:
                ScheduleView(viewModel: scheduleViewModelAssembly.build(), selectedGroup: viewsManager.selectedGroup)
                    .environmentObject(networkMonitor)
                    .environmentObject(viewsManager)
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(NetworkMonitor())
        .environmentObject(ViewsManager())
}
