//
//  URLSource.swift
//  SGU_Schedule
//
//  Created by Артемий on 25.09.2023.
//

import Foundation

public protocol URLSource {
    var baseString: String { get }
    var baseScheduleString: String { get }
    var baseScheduleURL: URL { get }
    func getScheduleUrlWithGroupParameter(parameter: String) -> URL
}
