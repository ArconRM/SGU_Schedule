//
//  ScheduleEventsFetchResult.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 04.08.2024.
//

import Foundation

enum ScheduleEventsFetchResult {
    case unknownErrorWhileFetching(error: Error? = nil)
    case noFavoriteGroup
    case success(currentEvent: (any ScheduleEvent)?, firstLesson: LessonDTO?, nextLesson: LessonDTO?)

    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    var currentEvent: (any ScheduleEvent)? {
        switch self {
        case .success(currentEvent: let currentEvent, firstLesson: _, nextLesson: _):
            return currentEvent
        default:
            return nil
        }
    }

    var firstLesson: LessonDTO? {
        switch self {
        case .success(currentEvent: _, firstLesson: let firstLesson, nextLesson: _):
            return firstLesson
        default:
            return nil
        }
    }

    var nextLesson: LessonDTO? {
        switch self {
        case .success(currentEvent: _, firstLesson: _, nextLesson: let nextLesson):
            return nextLesson
        default:
            return nil
        }
    }
}
