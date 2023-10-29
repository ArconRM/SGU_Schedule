//
//  ScheduleViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public protocol ScheduleViewModel: ObservableObject {
    var lessonsByDays: [[[LessonDTO]]] { get set }
    var currentEvent: (any EventDTO)? { get set }
    var nextLesson1: LessonDTO? { get set }
    var nextLesson2: LessonDTO? { get set }
    
    var favoriteGroupNumber: Int? { get set }
    
    var updateDate: Date { get set }
    
    var isLoadingLessons: Bool { get set }
    var isLoadingUpdateDate: Bool { get set }
    
    /// Fetches schedule's last update date.
    func fetchUpdateDate(groupNumber: Int)
    /// Fetches schedule and sets currentLesson and two next lessons.
    func fetchLessonsAndSetCurrentAndTwoNextLessons(groupNumber: Int, isOffline: Bool)
}
