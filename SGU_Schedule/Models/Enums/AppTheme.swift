//
//  AppTheme.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.07.2024.
//

import Foundation
import SwiftUI

public enum AppTheme: String, CaseIterable {
    case blue = "blue"
    case green = "green"
    case pink = "pink"
    case pinkHelloKitty = "pink HK" // люти рофл
    case gray = "gray"

    var rusValue: String {
        switch self {
        case .blue:
            return "син"
        case .green:
            return "зел"
        case .pink:
            return "роз"
        case .pinkHelloKitty:
            return "HK"
        case .gray:
            return "сер"
        }
    }

    func backgroundColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .blue:
            return .blue.opacity(colorScheme == .light ? 0.1 : 0.1)
        case .green:
            return .green.opacity(colorScheme == .light ? 0.1 : 0.1)
        case .pink, .pinkHelloKitty:
            return .pink.opacity(colorScheme == .light ? 0.1 : 0.1)
        case .gray:
            return colorScheme == .light ? .gray.opacity(0.1) : .gray.opacity(0.1)
        }
    }

    func mainGradientColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .blue:
            return .blue.opacity(colorScheme == .light ? 0.12 : 0.1)
        case .green:
            return .green.opacity(colorScheme == .light ? 0.15 : 0.1)
        case .pink, .pinkHelloKitty:
            return .pink.opacity(colorScheme == .light ? 0.1 : 0.1)
        case .gray:
            return colorScheme == .light ? .gray.opacity(0.17) : .gray.opacity(0.1)
        }
    }

    func pairedGradientColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .blue:
            return .cyan.opacity(colorScheme == .light ? 0.1 : 0)
        case .green:
            return .blue.opacity(colorScheme == .light ? 0.07 : 0.08)
        case .pink, .pinkHelloKitty:
            return .purple.opacity(colorScheme == .light ? 0.1 : 0.12)
        case .gray:
            return colorScheme == .light ? .white : .gray.opacity(0.03)
        }
    }

    func foregroundColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .blue:
            return .blue.opacity(colorScheme == .dark ? 1 : 0.6)
        case .green:
            return .green.opacity(colorScheme == .dark ? 1 : 0.8)
        case .pink, .pinkHelloKitty:
            return .pink.opacity(colorScheme == .dark ? 1 : 0.8)
        case .gray:
            return colorScheme == .light ? .black.opacity(0.3) : .gray.opacity(0.5)
        }
    }
}
