//
//  ScheduleURLSource.swift
//  SGU_Schedule
//
//  Created by Артемий on 25.09.2023.
//

import Foundation

public struct ScheduleURLSource: URLSource {
    public var baseURLAddress : String {
        return "https://www.sgu.ru/schedule/knt/do/"
    }
    
    public var baseURL: URL {
        guard let url = URL(string: baseURLAddress) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    public func getFullUrlWithParameter(parameter groupNumber : String) -> URL {
        return baseURL.appendingPathComponent(groupNumber)
    }
    
    public init() { }
}
