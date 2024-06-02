//
//  LessonNetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 30.09.2023.
//

import Foundation

public protocol LessonNetworkManager {
//    func getLessonsForDay(group: GroupDTO,
//                           day: Weekdays,
//                           resultQueue: DispatchQueue,
//                           completionHandler: @escaping(Result<[[LessonDTO]], Error>) -> Void)
    
    func getGroupScheduleForCurrentWeek(group: GroupDTO,
                                        resultQueue: DispatchQueue,
                                        completionHandler: @escaping(Result<GroupScheduleDTO, Error>) -> Void)
    
    func getTeacherScheduleForCurrentWeek(teacher: TeacherDTO,
                                          resultQueue: DispatchQueue,
                                          completionHandler: @escaping(Result<[LessonDTO], Error>) -> Void)
}
