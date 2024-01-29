//
//  GroupNetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public protocol GroupNetworkManager {
//    func getAllGroups(resultQueue: DispatchQueue,
//                      completionHandler: @escaping (Result<[Group], Error>) -> Void)
    
    ///May throw htmlParserError or any other
    func getGroupsByYearAndAcademicProgram(year: Int,
                                           program: AcademicProgram,
                                           resultQueue: DispatchQueue,
                                           completionHandler: @escaping (Result<[GroupDTO], Error>) -> Void)
}
