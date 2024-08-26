//
//  AcademicProgram.swift
//  SGU_Schedule
//
//  Created by Артемий on 14.10.2023.
//

import Foundation

public enum AcademicProgram: String, CaseIterable {
    case BachelorAndSpeciality = "Бакалавриат/Специалитет"
    case Masters = "Магистратура"
    case Postgraduade = "Аспирантура"
    
    public init?(rawValue: String) {
        switch rawValue {
        case "Бакалавриат", "Специалитет":
            self = .BachelorAndSpeciality
        case "Магистратура":
            self = .Masters
        case "Аспирантура":
            self = .Postgraduade
        default:
            return nil
        }
    }
}
