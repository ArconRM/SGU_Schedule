//
//  LessonNetworkManagerMock.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation
import SguParser

final class LessonNetworkManagerMock: LessonNetworkManager {
    func getGroupScheduleForCurrentWeek(
        group: AcademicGroupDTO,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<GroupScheduleDTO, Error>) -> Void
    ) {
        completionHandler(.success(
            GroupScheduleDTO.mock
        ))
    }

    func getTeacherScheduleForCurrentWeek(
        teacherEndpoint: String?,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<[LessonDTO], any Error>) -> Void
    ) {
        completionHandler(.success(LessonDTO.mocks))
    }
}
