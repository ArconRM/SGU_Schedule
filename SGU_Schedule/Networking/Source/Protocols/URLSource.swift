//
//  URLSource.swift
//  SGU_Schedule
//
//  Created by Артемий on 25.09.2023.
//

import Foundation

public protocol URLSource {
    func getBaseTeacherURL(teacherEndPoint: String) -> URL
    func getBaseScheduleURL(departmentCode: String) -> URL
    func getGroupScheduleURL(departmentCode: String, groupNumber: Int) -> URL
}
