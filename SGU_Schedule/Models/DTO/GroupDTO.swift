//
//  GroupDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation

public struct GroupDTO: Hashable {
    
    var academicProgram: AcademicProgram?
    var fullNumber: Int
    var shortName: String
    var fullName: String
    
    public init(fullNumber: Int) {
        self.fullNumber = fullNumber
            self.shortName = String(fullNumber)
        self.fullName = String(fullNumber) + " группа"
        
        if Array(String(fullNumber))[1] == "7" {
            self.academicProgram = .Masters
        } else if Array(String(fullNumber))[1] == "9" {
            self.academicProgram = .Postgraduade
        } else {
            self.academicProgram = .BachelorAndSpeciality
        }
    }
}
