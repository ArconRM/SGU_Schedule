//
//  MainView.swift
//  SGU_Schedule
//
//  Created by Артемий on 01.02.2024.
//

import SwiftUI

struct MainView<MainViewGroupsViewModel>: View where MainViewGroupsViewModel: GroupsViewModel {
    
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    var groupsViewModel: MainViewGroupsViewModel
    
    
    var body: some View {
        VStack {
            switch viewsManager.currentView {
            case .GroupsView:
                GroupsView(viewModel: groupsViewModel)
                    .environmentObject(networkMonitor)
                    .environmentObject(viewsManager)
            case .ScheduleView:
                ScheduleView(viewModel: ScheduleViewModelWithParsingSGU(), selectedGroup: viewsManager.selectedGroup)
                    .environmentObject(networkMonitor)
                    .environmentObject(viewsManager)
            }
        }
    }
}

#Preview {
    MainView(groupsViewModel: GroupsViewModelWithParsingSGU())
        .environmentObject(NetworkMonitor())
        .environmentObject(ViewsManager())
}
