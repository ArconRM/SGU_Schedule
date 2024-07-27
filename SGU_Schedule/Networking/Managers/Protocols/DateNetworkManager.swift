//
//  DateNetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public protocol DateNetworkManager {
    func getLastUpdateDate(
        group: GroupDTO,
        departmentCode: String,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<Date, Error>) -> Void
    )
}
