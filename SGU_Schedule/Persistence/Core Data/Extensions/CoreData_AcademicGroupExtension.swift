//
//  CoreData_AcademicGroupExtension.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 09.09.2024.
//

import Foundation

extension AcademicGroup {
    var groupId: String {
        return "\(self.departmentCode ?? "Error")_\(self.fullNumber ?? "Error")"
    }
}
