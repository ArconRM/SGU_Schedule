//
//  SessionEventsNetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation

protocol SessionEventsNetworkManager {
    func getGroupSessionEvents(
        group: AcademicGroupDTO,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<GroupSessionEventsDTO, Error>) -> Void
    )

    func getTeacherSessionEvents(
        teacherEndpoint: String?,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<[SessionEventDTO], Error>) -> Void
    )
}
