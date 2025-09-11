//
//  SGU_ScheduleApp.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI

@main
struct SGU_ScheduleApp: App {
    @StateObject private var notificationManager = NotificationManager(groupPersistenceManager: GroupCoreDataManager())
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State var widgetUrl: String?
    let appearanceSettings = AppearanceSettingsStore()
    let persistentUserSettings = PersistentUserSettingsStore()
    let routingState = RoutingState()

    @StateObject private var viewsManager: ViewsManager

    init() {
        let notificationManager = NotificationManager(groupPersistenceManager: GroupCoreDataManager())
        let appearanceSettings = AppearanceSettingsStore()
        let persistentUserSettings = PersistentUserSettingsStore()
        let routingState = RoutingState()

        _viewsManager = StateObject(wrappedValue:
            ViewsManagerWithParsingSGUFactory().makeViewsManager(
                appearanceSettings: appearanceSettings,
                persistentUserSettings: persistentUserSettings,
                routingState: routingState,
                notificationManager: notificationManager,
                widgetUrl: nil
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewsManager)
                .environmentObject(notificationManager)
                .environmentObject(NetworkMonitor())
                .environmentObject(appearanceSettings)
                .onOpenURL { url in
                    widgetUrl = url.absoluteString
                }
                .onAppear {
                    delegate.notificationManager = notificationManager
                    notificationManager.requestPermission()
                }
        }
    }
}
