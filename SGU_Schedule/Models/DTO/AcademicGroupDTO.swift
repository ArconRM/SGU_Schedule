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
        self.groupId = AcademicGroupDTO.makeId(fullNumber: fullNumber, departmentCode: departmentCode)
        self.departmentCode = departmentCode
        self.fullNumber = fullNumber
        self.shortName = fullNumber
        self.fullName = "\(fullNumber) группа"

        if Array(String(fullNumber))[1] == "7" {
            self.academicProgram = .masters
        } else if Array(String(fullNumber))[1] == "9" {
            self.academicProgram = .postgraduate
        } else {
            self.academicProgram = .bachelorAndSpeciality
        }
    }

    public static func makeId(fullNumber: String, departmentCode: String) -> String {
        return "\(departmentCode)_\(fullNumber)"
    }

//    static func extractDepartmentCodeFromId(groupId: String) -> String {
//        return String(groupId.split(separator: "_").first!)
//    }

    public static var mock: AcademicGroupDTO {
        return .init(fullNumber: "123", departmentCode: "test")
    }
}
