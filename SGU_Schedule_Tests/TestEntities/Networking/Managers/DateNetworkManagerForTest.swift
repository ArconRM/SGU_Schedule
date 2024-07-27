//
//  DateNetworkManagerForTest.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class DateNetworkManagerForTest: DateNetworkManager {
    func getLastUpdateDate(
        group: GroupDTO,
        departmentCode: String,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<Date, Error>) -> Void
    ) {
        Task { () -> Result<Date, Error> in
            return .success(Date())
        }
    }
}
