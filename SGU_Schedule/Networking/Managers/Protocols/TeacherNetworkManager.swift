//
//  TeacherNetworkManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 27.05.2024.
//

import Foundation

public protocol TeacherNetworkManager {
    func getTeacher(
        teacherEndpoint: String,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<TeacherDTO, Error>) -> Void
    )
}
