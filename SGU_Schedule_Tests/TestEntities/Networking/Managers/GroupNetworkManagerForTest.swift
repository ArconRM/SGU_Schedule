//
//  GroupNetworkManagerForTest.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class GroupNetworkManagerForTest: GroupsNetworkManager {
    func getGroupsByYearAndAcademicProgram(year: Int, program: AcademicProgram, resultQueue: DispatchQueue, completionHandler: @escaping (Result<[GroupDTO], Error>) -> Void) {
        Task { () -> Result<[GroupDTO], Error> in
            return .success([GroupDTO(fullNumber: 141), GroupDTO(fullNumber: 121), GroupDTO(fullNumber: 181)])
        }
    }
}
