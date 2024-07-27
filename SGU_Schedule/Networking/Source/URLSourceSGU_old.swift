//
//  ScheduleURLSource.swift
//  SGU_Schedule
//
//  Created by Артемий on 25.09.2023.
//

import Foundation

public struct URLSourceSGU_old: URLSource {
    private var baseUrl: URL {
        return URL(string: "https://old.sgu.ru")!
    }
    
    public func getBaseTeacherURL(teacherEndPoint: String) -> URL {
        return self.baseUrl.appendingPathComponent(teacherEndPoint)
    }
    
    public func getBaseScheduleURL(departmentCode: String) -> URL {
        return self.baseUrl.appendingPathComponent("schedule").appendingPathComponent(departmentCode)
    }
    
    public func getGroupScheduleURL(departmentCode: String, groupNumber: Int) -> URL {
        return self.getBaseScheduleURL(departmentCode: departmentCode).appendingPathComponent("do").appendingPathComponent(String(groupNumber))
    }
    
    public init() { }
}
