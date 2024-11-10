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
    
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    var body: some View {
        VStack {
            if UIDevice.isPhone {
                switch viewsManager.currentView {
                case .DepartmentsView:
                    viewsManager.buildDepartmentsView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appSettings)
                
                case .GroupsView:
                    viewsManager.buildGroupsView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appSettings)
                    
                case .ScheduleView:
                    viewsManager.buildScheduleView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appSettings)
                    
                case .TeacherView:
                    viewsManager.buildTeacherView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appSettings)
                    
                case .TeachersSearchView:
                    viewsManager.buildTeachersSearchView()
//                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appSettings)
                }
            } else if UIDevice.isPad {
                if viewsManager.currentView == .DepartmentsView {
                    viewsManager.buildDepartmentsView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appSettings)
                } else {
                    NavigationSplitView(columnVisibility: $columnVisibility) {
                        viewsManager.buildGroupsView()
                            .environmentObject(networkMonitor)
                            .environmentObject(viewsManager)
                            .environmentObject(appSettings)
//                            .navigationBarHidden(true)
                    } detail: {
                        if viewsManager.currentView == .ScheduleView {
                            viewsManager.buildScheduleView()
                                .environmentObject(networkMonitor)
                                .environmentObject(viewsManager)
                                .environmentObject(appSettings)
                                .id(UUID())
                            
                        } else if viewsManager.currentView == .TeacherView {
                            viewsManager.buildTeacherView()
                                .environmentObject(networkMonitor)
                                .environmentObject(viewsManager)
                                .environmentObject(appSettings)
                            
                        } else if viewsManager.currentView == .TeachersSearchView {
                            viewsManager.buildTeachersSearchView()
                                .environmentObject(networkMonitor)
                                .environmentObject(viewsManager)
                                .environmentObject(appSettings)
                            
                        } else {
                            viewsManager.buildSettingsView()
                                .environmentObject(appSettings)
//                                .navigationBarHidden(true)
                        }
                    }
                    .navigationSplitViewStyle(.balanced)
                    .accentColor(colorScheme == .light ? .black : .white)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
