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
    
    var body: some View {
        VStack {
            if UIDevice.isPhone {
                switch viewsManager.currentView {
                case .GroupsView:
                    self.viewsManager.buildGroupsView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                    
                case .ScheduleView:
                    self.viewsManager.buildScheduleView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                    
                case .TeacherInfoView:
                    self.viewsManager.buildTeacherInfoView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                    
                }
            } else if UIDevice.isPad {
                NavigationView {
                    self.viewsManager.buildGroupsView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                    
                    if self.viewsManager.currentView == .ScheduleView {
                        self.viewsManager.buildScheduleView()
                            .environmentObject(networkMonitor)
                            .environmentObject(viewsManager)
                            .id(UUID())
                    } else if self.viewsManager.currentView == .TeacherInfoView {
                        self.viewsManager.buildTeacherInfoView()
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
        .environmentObject(ViewsManager(viewModelFactory: ViewModelWithParsingSGUFactory()))
}
