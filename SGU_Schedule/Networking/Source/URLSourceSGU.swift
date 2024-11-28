//
//  URLSourceSGU.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 07.06.2024.
//

import Foundation

public struct URLSourceSGU: URLSource {
    private var baseUrl: URL {
        return URL(string: "https://www.sgu.ru")!
    }

    public func getBaseTeacherURL(teacherEndPoint: String) -> URL {
        return self.baseUrl.appendingPathComponent(teacherEndPoint)
    }

    public func getBaseScheduleURL(departmentCode: String) -> URL {
        return self.baseUrl.appendingPathComponent("schedule")
    }

    public func getGroupScheduleURL(departmentCode: String, groupNumber: String) -> URL {
        return self.getBaseScheduleURL(departmentCode: departmentCode).appendingPathComponent(departmentCode).appendingPathComponent("do").appendingPathComponent("\(groupNumber)")
    }

    public init() { }
}
