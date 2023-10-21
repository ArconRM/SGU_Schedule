//
//  ScheduleViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public protocol ScheduleViewModel: ObservableObject {
    var lessonsByDays: [[[Lesson]]] { get set }
    var currentLesson: Lesson? { get set }
    var twoNextLessons: [Lesson?] { get set }
    
    var updateDate: Date { get set }
    
    var isLoadingLessons: Bool { get set }
    var isLoadingUpdateDate: Bool { get set }
    
    /// Fetches schedule's last update date.
    func fetchUpdateDate(groupNumber: Int)
    /// Fetches schedule and sets currentLesson and twoNextLessons.
    func fetchLessonsAndSetCurrentAndTwoNextLessons(groupNumber: Int)
}
