//
//  AppSettings.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.07.2024.
//

import Foundation
import SwiftUI


class AppSettings: ObservableObject {
    @AppStorage(UserDefaultsKeys.selectedAppTheme.rawValue, store: UserDefaults(suiteName: "group.com.qwerty.SGUSchedule")) var currentAppTheme: String = AppTheme.blue.rawValue
    @AppStorage(UserDefaultsKeys.selectedAppStyle.rawValue, store: UserDefaults(suiteName: "group.com.qwerty.SGUSchedule")) var currentAppStyle: String = AppStyle.fill.rawValue
}
