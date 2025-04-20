//
//  SGU_ScheduleApp.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI

@main
struct SGU_ScheduleApp: App {

    @State var widgetUrl: String?
    let appearanceSettings = AppearanceSettingsStore()
    let persistentUserSettings = PersistentUserSettingsStore()
    let routingState = RoutingState()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(
                    ViewsManagerWithParsingSGUFactory().makeViewsManager(
                        appearanceSettings: appearanceSettings,
                        persistentUserSettings: persistentUserSettings,
                        routingState: routingState,
                        widgetUrl: widgetUrl
                    )
                )
                .environmentObject(NetworkMonitor())
                .environmentObject(appearanceSettings)
                .onOpenURL { url in
                    widgetUrl = url.absoluteString
                }
        }
    }
}
