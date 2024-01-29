//
//  LessonsNetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 30.09.2023.
//

import Foundation

public protocol LessonsNetworkManager {
//    func getLessonsForDay(group: GroupDTO,
//                           day: Weekdays,
//                           resultQueue: DispatchQueue,
//                           completionHandler: @escaping(Result<[[LessonDTO]], Error>) -> Void)
    
    /// May throw htmlParserError or any other
    func getGroupScheduleForCurrentWeek(group: GroupDTO,
                                        resultQueue: DispatchQueue,
                                        completionHandler: @escaping(Result<GroupScheduleDTO, Error>) -> Void)
}
