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
    case PinkHelloKitty = "pink HK" // люти рофл
    case Gray = "gray"
    
    var rusValue: String {
        switch self {
        case .Blue:
            return "син"
        case .Green:
            return "зел"
        case .Pink:
            return "роз"
        case .PinkHelloKitty:
            return "HK"
        case .Gray:
            return "сер"
        }
    }
    
    func backgroundColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .Blue:
            return .blue.opacity(colorScheme == .light ? 0.1 : 0.1)
        case .Green:
            return .green.opacity(colorScheme == .light ? 0.1 : 0.1)
        case .Pink, .PinkHelloKitty:
            return .pink.opacity(colorScheme == .light ? 0.1 : 0.1)
        case .Gray:
            return colorScheme == .light ? .gray.opacity(0.1) : .gray.opacity(0.1)
        }
    }
    
    func mainGradientColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .Blue:
            return .blue.opacity(colorScheme == .light ? 0.12 : 0.1)
        case .Green:
            return .green.opacity(colorScheme == .light ? 0.15 : 0.1)
        case .Pink, .PinkHelloKitty:
            return .pink.opacity(colorScheme == .light ? 0.1 : 0.1)
        case .Gray:
            return colorScheme == .light ? .gray.opacity(0.17) : .gray.opacity(0.1)
        }
    }
    
    func pairedGradientColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .Blue:
            return .cyan.opacity(colorScheme == .light ? 0.1 : 0)
        case .Green:
            return .blue.opacity(colorScheme == .light ? 0.07 : 0.08)
        case .Pink, .PinkHelloKitty:
            return .purple.opacity(colorScheme == .light ? 0.1 : 0.12)
        case .Gray:
            return colorScheme == .light ? .white : .gray.opacity(0.03)
        }
    }
    
    func foregroundColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .Blue:
            return .blue.opacity(colorScheme == .dark ? 1 : 0.8)
        case .Green:
            return .green.opacity(colorScheme == .dark ? 1 : 0.8)
        case .Pink, .PinkHelloKitty:
            return .pink.opacity(colorScheme == .dark ? 1 : 0.8)
        case .Gray:
            return colorScheme == .light ? .black.opacity(0.3) : .gray.opacity(0.5)
        }
    }
}
