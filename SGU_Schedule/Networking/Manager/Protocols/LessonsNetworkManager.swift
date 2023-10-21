//
//  LessonsNetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 30.09.2023.
//

import Foundation

public protocol LessonsNetworkManager : NetworkManager {
    func getLessonsForDay(group: Group,
                           day: Weekdays,
                           resultQueue: DispatchQueue,
                           completionHandler: @escaping(Result<[[Lesson]], Error>) -> Void)
    
    func getLessonsForCurrentWeek(group: Group,
                                   resultQueue: DispatchQueue,
                                   completionHandler: @escaping(Result<[[[Lesson]]], Error>) -> Void)
}
