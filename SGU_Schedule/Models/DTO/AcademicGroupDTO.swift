//
//  AcademicGroupDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation

public struct AcademicGroupDTO: Hashable {
    
    var groupId: String
    var academicProgram: AcademicProgram
    var departmentCode: String
    var fullNumber: String
    var shortName: String
    var fullName: String
    
    public init(fullNumber: String, departmentCode: String) {
        self.groupId = "\(departmentCode)_\(fullNumber)"
        self.departmentCode = departmentCode
        self.fullNumber = fullNumber
        self.shortName = fullNumber
        self.fullName = "\(fullNumber) группа"
        
        if Array(String(fullNumber))[1] == "7" {
            self.academicProgram = .Masters
        } else if Array(String(fullNumber))[1] == "9" {
            self.academicProgram = .Postgraduate
        } else {
            self.academicProgram = .BachelorAndSpeciality
        }
    }
}
