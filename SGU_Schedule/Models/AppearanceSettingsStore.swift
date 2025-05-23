//
//  AppearanceSettingsStore.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.07.2024.
//

import Foundation
import SwiftUI

final class AppearanceSettingsStore: ObservableObject {
    @AppStorage(UserDefaultsKeys.selectedAppTheme.rawValue, store: UserDefaults(suiteName: AppGroup.schedule.rawValue)) var currentAppThemeValue: String = AppTheme.blue.rawValue
    @AppStorage(UserDefaultsKeys.selectedAppStyle.rawValue, store: UserDefaults(suiteName: AppGroup.schedule.rawValue)) var currentAppStyleValue: String = AppStyle.fill.rawValue

    public var currentAppTheme: AppTheme {
        AppTheme(rawValue: currentAppThemeValue) ?? AppTheme.blue
    }

    public var currentAppStyle: AppStyle {
        AppStyle(rawValue: currentAppStyleValue) ?? AppStyle.fill
    }
}
