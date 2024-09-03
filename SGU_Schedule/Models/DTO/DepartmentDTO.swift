//
//  DepartmentDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 08.02.2024.
//

import Foundation

public struct DepartmentDTO: Hashable {
    var fullName: String
    var code: String
    
    init(fullName: String, code: String) {
        self.fullName = fullName
        self.code = code
    }
    
    var number: Int {
        var value = 1
        for depCase in DepartmentSource.allCases {
            if depCase.dto.code != self.code {
                value += 1
            } else {
                break
            }
        }
        return value
    }
}
