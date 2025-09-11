//
//  AppGroup.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 06.08.2024.
//

import Foundation

public enum AppGroup: String {
  case schedule = "group.com.qwerty.SGUSchedule"

  public var containerURL: URL {
    switch self {
    case .schedule:
      return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
