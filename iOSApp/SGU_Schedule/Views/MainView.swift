//
//  MainView.swift
//  SGU_Schedule
//
//  Created by Артемий on 01.02.2024.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore

    @State private var currentView: AppViews = .departmentsView
    @State private var hasAppeared = false

    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn

    var body: some View {
        VStack {
            if UIDevice.isPhone {
                switch currentView {
                case .departmentsView:
                    viewsManager.buildDepartmentsView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appearanceSettings)

                case .groupsView:
                    viewsManager.buildGroupsView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appearanceSettings)

                case .scheduleView:
                    viewsManager.buildScheduleView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appearanceSettings)

                case .sessionEventsView:
                    viewsManager.buildScheduleView(showSessionEventsView: true)
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appearanceSettings)

                case .teacherView:
                    viewsManager.buildTeacherView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appearanceSettings)

                case .teachersSearchView:
                    viewsManager.buildTeachersSearchView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appearanceSettings)
                }
            } else if UIDevice.isPad {
                if currentView == .departmentsView {
                    viewsManager.buildDepartmentsView()
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)
                        .environmentObject(appearanceSettings)
                } else {
                    NavigationSplitView(columnVisibility: $columnVisibility) {
                                viewsManager.buildGroupsView()
                            .toolbar(removing: .sidebarToggle)
                                    .environmentObject(networkMonitor)
                                    .environmentObject(viewsManager)
                                    .environmentObject(appearanceSettings)
                            } detail: {
                                if currentView == .scheduleView {
                                    viewsManager.buildScheduleView()
                                        .environmentObject(networkMonitor)
                                        .environmentObject(viewsManager)
                                        .environmentObject(appearanceSettings)
                                        .id(UUID())

                                } else if currentView == .teacherView {
                                    viewsManager.buildTeacherView()
                                        .environmentObject(networkMonitor)
                                        .environmentObject(viewsManager)
                                        .environmentObject(appearanceSettings)

                                } else {
                                    viewsManager.buildSettingsView()
                                        .environmentObject(appearanceSettings)
                                }
                            }
                            .navigationSplitViewStyle(.balanced)
                            .accentColor(colorScheme == .light ? .black : .white)
                }
            }
        }
        .onReceive(viewsManager.currentViewPublisher) { newView in
            if !hasAppeared {
                currentView = newView
            } else if currentView != newView {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentView = newView
                }
            }
        }

        .onAppear {
            hasAppeared = true
        }
    }
}

#Preview {
    MainView()
}
