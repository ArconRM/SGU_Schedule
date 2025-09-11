//
//  CoreData_AcademicGroupExtension.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 09.09.2024.
//

import Foundation
import SguParser

extension AcademicGroup {
    var groupId: String {
        return AcademicGroupDTO.makeId(fullNumber: self.fullNumber ?? "Error", departmentCode: self.departmentCode ?? "Error")
    }
}
