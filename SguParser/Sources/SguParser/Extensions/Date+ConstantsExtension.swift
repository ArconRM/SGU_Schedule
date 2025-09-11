//
//  Date+ConstantsExtension.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 10.01.2025.
//

import Foundation

extension Date {
    private static let consultationDurationHours = 3
    private static let examinationDurationHours = 5

    public static func getDurationHours(sessionEventType: SessionEventType) -> Int {
        switch sessionEventType {
        case .consultation:
            return consultationDurationHours
        default:
            return examinationDurationHours
        }
    }
}
