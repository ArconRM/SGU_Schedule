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
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        VStack {
            if UIDevice.isPhone {
                switch viewsManager.currentView {
                case .DepartmentsView:
                    self.viewsManager.buildDepartmentsView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appSettings)
                
                case .GroupsView:
                    self.viewsManager.buildGroupsView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appSettings)
                    
                case .ScheduleView:
                    self.viewsManager.buildScheduleView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appSettings)
                    
                case .TeacherInfoView:
                    self.viewsManager.buildTeacherInfoView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appSettings)
                    
                }
            } else if UIDevice.isPad {
                if self.viewsManager.currentView == .DepartmentsView {
                    self.viewsManager.buildDepartmentsView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appSettings)
                } else {
                    NavigationView {
                        self.viewsManager.buildGroupsView()
                            .environmentObject(networkMonitor)
                            .environmentObject(viewsManager)
                            .environmentObject(appSettings)
                        
                        if self.viewsManager.currentView == .ScheduleView {
                            self.viewsManager.buildScheduleView()
                                .environmentObject(networkMonitor)
                                .environmentObject(viewsManager)
                                .environmentObject(appSettings)
                                .id(UUID())
                        } else if self.viewsManager.currentView == .TeacherInfoView {
                            self.viewsManager.buildTeacherInfoView()
                                .environmentObject(networkMonitor)
                                .environmentObject(viewsManager)
                                .environmentObject(appSettings)
                        }
                    }
                    .accentColor(colorScheme == .light ? .black : .white)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
