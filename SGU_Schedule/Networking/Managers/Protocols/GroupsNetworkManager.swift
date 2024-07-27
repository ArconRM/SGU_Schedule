//
//  GroupsNetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public protocol GroupsNetworkManager {
    ///May throw htmlParserError or any other
    func getGroupsByYearAndAcademicProgram(
        year: Int,
        program: AcademicProgram,
        departmentCode: String,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<[GroupDTO], Error>) -> Void
    )
}
