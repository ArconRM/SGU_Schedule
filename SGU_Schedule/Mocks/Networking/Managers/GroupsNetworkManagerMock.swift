//
//  GroupsNetworkManagerMock.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

final class GroupsNetworkManagerMock: GroupsNetworkManager {
    func getGroupsByYearAndAcademicProgram(
        year: Int,
        program: AcademicProgram,
        department: Department,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<[AcademicGroupDTO], Error>) -> Void
    ) {
        completionHandler(.success([AcademicGroupDTO.mock]))
    }
}
