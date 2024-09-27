//
//  AppSettings.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.07.2024.
//

import Foundation
import SwiftUI


class AppSettings: ObservableObject {
    @AppStorage(UserDefaultsKeys.selectedAppTheme.rawValue, store: UserDefaults(suiteName: "group.com.qwerty.SGUSchedule")) var currentAppThemeValue: String = AppTheme.Blue.rawValue
    @AppStorage(UserDefaultsKeys.selectedAppStyle.rawValue, store: UserDefaults(suiteName: "group.com.qwerty.SGUSchedule")) var currentAppStyleValue: String = AppStyle.Fill.rawValue
    
    public var currentAppTheme: AppTheme {
        AppTheme(rawValue: currentAppThemeValue) ?? AppTheme.Blue
    }
    
    public var currentAppStyle: AppStyle {
        AppStyle(rawValue: currentAppStyleValue) ?? AppStyle.Fill
    }
}
