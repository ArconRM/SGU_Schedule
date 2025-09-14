//
//  PersistentUserSettingsStore.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 16.04.2025.
//

import Foundation
import SguParser

final class PersistentUserSettingsStore: ObservableObject {
    @Published var isNewParserUsed: Bool {
        didSet {
            UserDefaults.standard.set(isNewParserUsed, forKey: UserDefaultsKeys.isNewParserUsed.rawValue)
        }
    }

    @Published var selectedDepartment: DepartmentDTO? {
        didSet {
            UserDefaults.standard.setValue(selectedDepartment?.code, forKey: UserDefaultsKeys.selectedDepartmentKey.rawValue)
        }
    }

    @Published var favouriteGroupNumber: String? {
        didSet {
            UserDefaults.standard.set(favouriteGroupNumber, forKey: UserDefaultsKeys.favoriteGroupNumberKey.rawValue)
        }
    }

    @Published var isRegisteredForNotifications: Bool {
        didSet {
            UserDefaults.standard.set(isRegisteredForNotifications, forKey: UserDefaultsKeys.isRegisteredForNotifications.rawValue)
        }
    }

    init() {
        self.isNewParserUsed = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isNewParserUsed.rawValue)
        self.selectedDepartment = {
            if let departmentCode = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedDepartmentKey.rawValue) {
                return DepartmentDTO(code: departmentCode)
            }
            return nil
        }()
        self.favouriteGroupNumber = UserDefaults.standard.string(forKey: UserDefaultsKeys.favoriteGroupNumberKey.rawValue)
        self.isRegisteredForNotifications = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isRegisteredForNotifications.rawValue)
    }
}
