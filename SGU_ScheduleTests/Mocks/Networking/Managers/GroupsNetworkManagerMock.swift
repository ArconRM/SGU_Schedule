//
//  GroupsNetworkManagerMock.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class GroupsNetworkManagerMock: GroupsNetworkManager {
    func getGroupsByYearAndAcademicProgram(
        year: Int,
        program: AcademicProgram,
        department: Department,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<[AcademicGroupDTO], Error>) -> Void) {
        Task { () -> Result<[AcademicGroupDTO], Error> in
            return .success([AcademicGroupDTO(fullNumber: "141", departmentCode: department.code),
                             AcademicGroupDTO(fullNumber: "121", departmentCode: department.code),
                             AcademicGroupDTO(fullNumber: "181", departmentCode: department.code)])
        }
    }
}
