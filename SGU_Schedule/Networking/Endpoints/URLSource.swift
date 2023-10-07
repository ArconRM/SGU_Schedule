//
//  URLSource.swift
//  SGU_Schedule
//
//  Created by Артемий on 25.09.2023.
//

import Foundation

public protocol URLSource {
    var baseURLAddress: String { get }
    var baseURL: URL { get }
    func getFullUrlWithParameter(parameter: String) -> URL
}
