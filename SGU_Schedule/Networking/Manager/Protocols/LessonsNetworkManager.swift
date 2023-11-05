//
//  LessonsNetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 30.09.2023.
//

import Foundation

public protocol LessonsNetworkManager : NetworkManager {
//    func getLessonsForDay(group: GroupDTO,
//                           day: Weekdays,
//                           resultQueue: DispatchQueue,
//                           completionHandler: @escaping(Result<[[LessonDTO]], Error>) -> Void)
    
    func getGroupScheduleForCurrentWeek(group: GroupDTO,
                                   resultQueue: DispatchQueue,
                                   completionHandler: @escaping(Result<GroupScheduleDTO, Error>) -> Void)
}
