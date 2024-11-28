//
//  AppSettings.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.07.2024.
//

import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage(UserDefaultsKeys.selectedAppTheme.rawValue, store: UserDefaults(suiteName: "group.com.qwerty.SGUSchedule")) var currentAppThemeValue: String = AppTheme.blue.rawValue
    @AppStorage(UserDefaultsKeys.selectedAppStyle.rawValue, store: UserDefaults(suiteName: "group.com.qwerty.SGUSchedule")) var currentAppStyleValue: String = AppStyle.fill.rawValue

    public var currentAppTheme: AppTheme {
        AppTheme(rawValue: currentAppThemeValue) ?? AppTheme.blue
    }

    public var currentAppStyle: AppStyle {
        AppStyle(rawValue: currentAppStyleValue) ?? AppStyle.fill
    }
}
