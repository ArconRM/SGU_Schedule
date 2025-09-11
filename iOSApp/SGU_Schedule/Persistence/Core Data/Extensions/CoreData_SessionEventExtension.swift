//
//  CoreData_SessionEventExtension.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 07.01.2025.
//

import Foundation
import SguParser

extension SessionEvent {
    var sessionEventType: SessionEventType {
        get {
            return SessionEventType(rawValue: self.sessionEventTypeRawValue ?? "") ?? .exam
        }
        set {
            self.sessionEventTypeRawValue = newValue.rawValue
        }
    }

}
