//
//  GroupsNetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public protocol GroupsNetworkManager {
    func getGroupsByYearAndAcademicProgram(
        year: Int,
        program: AcademicProgram,
        department: DepartmentDTO,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<[AcademicGroupDTO], Error>) -> Void
    )
}
