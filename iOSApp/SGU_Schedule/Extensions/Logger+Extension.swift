//
//  Logger+Extension.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 07.09.2025.
//

import Foundation
import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier!
    static let errorLogger = Logger(subsystem: subsystem, category: "errors")
}
