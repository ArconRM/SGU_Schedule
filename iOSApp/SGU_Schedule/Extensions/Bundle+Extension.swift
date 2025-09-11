//
//  BundleExtension.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.10.2024.
//

import Foundation

extension Bundle {
    var appVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var appBuild: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
