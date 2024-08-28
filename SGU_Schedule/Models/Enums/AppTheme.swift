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
    case gray = "gray"
    
    var rusValue: String {
        switch self {
        case .blue:
            return "син"
        case .green:
            return "зел"
        case .pink:
            return "роз"
        case .gray:
            return "сер"
        }
    }
    
    func backgroundColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .blue:
            return .blue.opacity(colorScheme == .dark ? 0.1 : 0.07)
        case .green:
            return .green.opacity(colorScheme == .dark ? 0.1 : 0.07)
        case .pink:
            return .pink.opacity(colorScheme == .dark ? 0.1 : 0.07)
        case .gray:
            return colorScheme == .light ? .white : .black
        }
    }
    
    func foregroundColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .blue:
            return .blue.opacity(colorScheme == .dark ? 1 : 0.8)
        case .green:
            return .green.opacity(colorScheme == .dark ? 1 : 0.8)
        case .pink:
            return .pink.opacity(colorScheme == .dark ? 1 : 0.8)
        case .gray:
            return colorScheme == .light ? .black.opacity(0.3) : .black
        }
    }
}
