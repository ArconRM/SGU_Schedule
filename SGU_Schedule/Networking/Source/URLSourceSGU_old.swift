//
//  ScheduleURLSource.swift
//  SGU_Schedule
//
//  Created by Артемий on 25.09.2023.
//

import Foundation

public struct URLSourceSGU_old: URLSource {
    public var baseString: String {
        return "https://old.sgu.ru"
    }
    
    public var baseScheduleString: String {
        return "https://old.sgu.ru/schedule/knt"
    }
    
    public var baseScheduleURL: URL {
        let url = URL(string: baseScheduleString)!
        return url
    }
    
    public func getScheduleUrlWithGroupParameter(parameter groupNumber : String) -> URL {
        return baseScheduleURL.appendingPathComponent("do/" + groupNumber)
    }
    
    public init() { }
}
