//
//  TeacherNetworkManagerMock.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation
import SguParser

final class TeacherNetworkManagerMock: TeacherNetworkManager {
    func getTeacher(
        teacherEndpoint: String,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<SguParser.TeacherDTO, any Error>) -> Void
    ) {
        completionHandler(.success(TeacherDTO.mock))
    }

    func getAllTeachers(
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<Set<SguParser.TeacherSearchResult>, any Error>) -> Void
    ) {
        completionHandler(.success(Set(TeacherSearchResult.mocks)))
    }
}
