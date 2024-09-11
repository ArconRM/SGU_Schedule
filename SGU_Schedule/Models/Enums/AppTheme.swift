//
//  AppTheme.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.07.2024.
//

import Foundation
import SwiftUI

public enum AppTheme: String, CaseIterable {
    case Blue = "blue"
    case Green = "green"
    case Pink = "pink"
    case Gray = "gray"
    
    var rusValue: String {
        switch self {
        case .Blue:
            return "син"
        case .Green:
            return "зел"
        case .Pink:
            return "роз"
        case .Gray:
            return "сер"
        }
    }
    
    func backgroundColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .Blue:
            return .blue.opacity(colorScheme == .dark ? 0.1 : 0.07)
        case .Green:
            return .green.opacity(colorScheme == .dark ? 0.1 : 0.07)
        case .Pink:
            return .pink.opacity(colorScheme == .dark ? 0.1 : 0.07)
        case .Gray:
            return colorScheme == .light ? .white : .black
        }
    }
    
    func foregroundColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .Blue:
            return .blue.opacity(colorScheme == .dark ? 1 : 0.8)
        case .Green:
            return .green.opacity(colorScheme == .dark ? 1 : 0.8)
        case .Pink:
            return .pink.opacity(colorScheme == .dark ? 1 : 0.8)
        case .Gray:
            return colorScheme == .light ? .black.opacity(0.3) : .black
        }
    }
}
