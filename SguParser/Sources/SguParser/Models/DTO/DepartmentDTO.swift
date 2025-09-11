//
//  DepartmentDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 08.02.2024.
//

import Foundation

public struct DepartmentDTO: Hashable {
    public var fullName: String
    public var shortName: String
    public var code: String

    public init(code: String) {
        self.code = code
        self.fullName = DepartmentSource(rawValue: code)?.fullName ?? "Error"
        self.shortName = DepartmentSource(rawValue: code)?.shortName ?? "Error"
    }

    public var number: Int {
        var value = 1
        for depCase in DepartmentSource.allCases {
            if depCase.rawValue != self.code {
                value += 1
            } else {
                break
            }
        }
        return value
    }

    public static var mock: Self {
        .init(code: "Ошибка")
    }
}
