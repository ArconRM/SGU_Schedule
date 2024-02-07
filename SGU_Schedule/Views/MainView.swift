//
//  MainView.swift
//  SGU_Schedule
//
//  Created by Артемий on 01.02.2024.
//

import SwiftUI

//TODO: мб все таки через интерфейсы как-то, пока для теста нужно создавать отдельную mainview
struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    
    let groupsViewModel = GroupsViewModelWithParsingSGUAssembly().build()
    let scheduleViewModelAssembly = ScheduleViewModelWithParsingSGUAssembly()
    
    var body: some View {
        VStack {
            if UIDevice.isPhone {
                switch viewsManager.currentView {
                case .GroupsView:
                    GroupsView(viewModel: groupsViewModel)
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                    
                case .ScheduleView:
                    ScheduleView(viewModel: scheduleViewModelAssembly.build(), selectedGroup: $viewsManager.selectedGroup)
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                }
            } else if UIDevice.isPad {
                NavigationView {
                    GroupsView(viewModel: groupsViewModel)
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                    
                    if viewsManager.currentView == .ScheduleView {
                        ScheduleView(viewModel: scheduleViewModelAssembly.build(), selectedGroup: $viewsManager.selectedGroup)
                            .environmentObject(networkMonitor)
                            .environmentObject(viewsManager)
                    }
                }
                .accentColor(colorScheme == .light ? .black : .white)
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(NetworkMonitor())
        .environmentObject(ViewsManager())
}
