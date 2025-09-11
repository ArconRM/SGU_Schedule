//
//  LessonNetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 30.09.2023.
//

import Foundation
import SguParser

protocol LessonNetworkManager {
    func getGroupScheduleForCurrentWeek(
        group: AcademicGroupDTO,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<GroupScheduleDTO, Error>) -> Void
    )

    func getTeacherScheduleForCurrentWeek(
        teacherEndpoint: String?,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<[LessonDTO], Error>) -> Void
    )
}
