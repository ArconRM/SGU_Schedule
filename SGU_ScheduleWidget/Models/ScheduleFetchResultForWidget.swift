//
//  ScheduleFetchResultForWidget.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 04.08.2024.
//

import Foundation

class ScheduleFetchResultForWidget {
    private(set) var resultVariant: ScheduleFetchResultVariants
    private(set) var firstLesson: LessonDTO?
    private(set) var currentEvent: (any ScheduleEvent)?
    private(set) var nextLesson: LessonDTO?
    
    init(
        resultVariant: ScheduleFetchResultVariants,
        firstLesson: LessonDTO? = nil,
        currentEvent: (any ScheduleEvent)? = nil,
        nextLesson: LessonDTO? = nil
    ) {
        self.resultVariant = resultVariant
        self.firstLesson = firstLesson
        self.currentEvent = currentEvent
        self.nextLesson = nextLesson
    }
}
