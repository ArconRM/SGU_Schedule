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
    let appSettings = AppSettings()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(
                    ViewsManagerWithParsingSGUFactory().makeViewsManager(appSettings: appSettings, widgetUrl: widgetUrl)
                )
                .environmentObject(NetworkMonitor())
                .environmentObject(appSettings)
                .onOpenURL { url in
                    widgetUrl = url.absoluteString
                }
        }
    }
}
