//
//  TeacherNetworkManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 27.05.2024.
//

import Foundation

public protocol TeacherNetworkManager {
    
    /// Только через старый сайт
    func getTeacher(
        teacherEndpoint: String,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<Teacher, Error>) -> Void
    )
    
    
    /// Только через новый сайт. Заполняет пока только основную инфу
    func getAllTeachers(
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<Set<TeacherSearchResult>, Error>) -> Void
    )
}
