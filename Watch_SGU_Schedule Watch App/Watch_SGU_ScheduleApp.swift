//
//  Watch_SGU_ScheduleApp.swift
//  Watch_SGU_Schedule Watch App
//
//  Created by Артемий on 17.11.2023.
//

import SwiftUI

@main
struct Watch_SGU_Schedule_Watch_AppApp: App {
    @State var selectedGroupNumber: Int? = {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: UserDefaultsKey.selectedGroupNumber.rawValue) {
            return userDefaults.integer(forKey: UserDefaultsKey.selectedGroupNumber.rawValue)
        }
        return nil
    }()
    var body: some Scene {
        WindowGroup {
            if selectedGroupNumber == nil {
                GroupsView(viewModel: GroupsViewModelWithParsingSGU(), selectedGroupNumber: $selectedGroupNumber)
            } else {
                ScheduleView(viewModel: ScheduleViewModelWithParsingSGU(), selectedGroupNumber: $selectedGroupNumber)
            }
        }
        .onChange(of: selectedGroupNumber) { newValue in
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(newValue, forKey: UserDefaultsKey.selectedGroupNumber.rawValue)
        }
    }
}
