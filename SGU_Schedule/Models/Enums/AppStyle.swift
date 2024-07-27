//
//  Style.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 27.07.2024.
//

import Foundation

public enum AppStyle: String, CaseIterable {
    case fill = "fill"
    case bordered = "bordered"
    
    var rusValue: String {
        switch self {
        case .fill:
            return "заполн"
        case .bordered:
            return "обвод"
        }
    }
}

