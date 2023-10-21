//
//  DateNetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation
public protocol DateNetworkManager: NetworkManager {
    func getLastUpdateDate(group: Group,
                           resultQueue: DispatchQueue,
                           completionHandler: @escaping (Result<Date, Error>) -> Void)
}
