//
//  SessionEventsNetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation

public protocol SessionEventsNetworkManager {
    func getGroupSessionEvents(
        group: AcademicGroupDTO,
        resultQueue: DispatchQueue,
        completionHandler: @escaping(Result<GroupSessionEventsDTO, Error>) -> Void
    )
    
    func getTeacherSessionEvents(
        teacher: TeacherDTO,
        resultQueue: DispatchQueue,
        completionHandler: @escaping(Result<[SessionEventDTO], Error>) -> Void
    )
}

