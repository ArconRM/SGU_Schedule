//
//  ScheduleFetchResult.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 04.08.2024.
//

import Foundation

class ScheduleFetchResult {
    private(set) var resultVariant: ScheduleFetchResultVariants
    private(set) var currentEvent: (any ScheduleEventDTO)?
    private(set) var nextLesson: LessonDTO?
    
    init(
        resultVariant: ScheduleFetchResultVariants,
        currentEvent: (any ScheduleEventDTO)? = nil,
        nextLesson: LessonDTO? = nil
    ) {
        self.resultVariant = resultVariant
        self.currentEvent = currentEvent
        self.nextLesson = nextLesson
    }
    
//    func setNewValues(
//        resultVariant: ScheduleWidgetViewModelResultVariants,
//        currentEvent: (any ScheduleEventDTO)? = nil,
//        nextLesson: LessonDTO? = nil
//    ) {
//        self.resultVariant = resultVariant
//        self.currentEvent = currentEvent
//        self.nextLesson = nextLesson
//    }
    
}
