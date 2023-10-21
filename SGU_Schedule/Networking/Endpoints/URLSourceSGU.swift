//
//  ScheduleURLSource.swift
//  SGU_Schedule
//
//  Created by Артемий on 25.09.2023.
//

import Foundation

public struct URLSourceSGU: URLSource {
    public var baseURLAddress : String {
        return "https://www.sgu.ru/schedule/knt"
    }
    
    public var baseURL: URL {
        guard let url = URL(string: baseURLAddress) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    public func getUrlWithGroupParameter(parameter groupNumber : String) -> URL {
        return baseURL.appendingPathComponent("do/" + groupNumber)
    }
    
    public init() { }
}
