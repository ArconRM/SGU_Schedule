//
//  ScheduleViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public protocol ScheduleViewModel: ObservableObject {
    var schedule: GroupScheduleDTO? { get set }
    var currentEvent: (any EventDTO)? { get set }
    
    var nextLesson1: LessonDTO? { get set }
    var nextLesson2: LessonDTO? { get set }
    
    var updateDate: Date { get set }
    
    var isLoadingLessons: Bool { get set }
    var isLoadingUpdateDate: Bool { get set }
    
    var isShowingError: Bool { get set }
    var activeError: LocalizedError? { get set }
    
    var favoriteGroupNumber: Int? { get set }

    /// Fetches schedule's last updateDate, fetches schedule by group and sets current lesson and two next lessons.
    func fetchUpdateDateAndLessons(groupNumber: Int, isOnline: Bool)
}
