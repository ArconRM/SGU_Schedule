//
//  SessionEventsNetworkManagerMock.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation
import SguParser

final class SessionEventsNetworkManagerMock: SessionEventsNetworkManager {
    func getGroupSessionEvents(
        group: AcademicGroupDTO,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<GroupSessionEventsDTO, Error>) -> Void
    ) {
        completionHandler(.success(
            GroupSessionEventsDTO(
                groupNumber: group.fullNumber,
                departmentCode: group.departmentCode,
                sessionEvents: SessionEventDTO.mocks
            )
        ))
    }

    func getTeacherSessionEvents(
        teacherEndpoint: String?,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<[SessionEventDTO], any Error>) -> Void
    ) {
        completionHandler(.success(SessionEventDTO.mocks))
    }
}
