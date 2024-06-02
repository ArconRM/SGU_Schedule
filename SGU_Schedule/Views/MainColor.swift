//
//  MainColor.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 28.05.2024.
//

import Foundation
import SwiftUI

public func mainColorView(isDark: Bool) -> Color {
    return Color.blue.opacity(isDark ? 0.1 : 0.07)
}
