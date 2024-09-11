//
//  Style.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 27.07.2024.
//

import Foundation

public enum AppStyle: String, CaseIterable {
    case Fill = "fill"
    case Bordered = "bordered"
    
    var rusValue: String {
        switch self {
        case .Fill:
            return "заполн"
        case .Bordered:
            return "обвод"
        }
    }
}

