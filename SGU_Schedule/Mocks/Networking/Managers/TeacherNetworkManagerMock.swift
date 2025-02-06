//
//  TeacherNetworkManagerMock.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation

final class TeacherNetworkManagerMock: TeacherNetworkManager {
    func getTeacher(
        teacherEndpoint: String,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<SGU_Schedule.Teacher, any Error>) -> Void
    ) {
        completionHandler(.success(Teacher.mock))
    }

    func getAllTeachers(
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<Set<SGU_Schedule.TeacherSearchResult>, any Error>) -> Void
    ) {
        completionHandler(.success(Set(TeacherSearchResult.mocks)))
    }
}
