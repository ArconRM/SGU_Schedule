//
//  Teacher.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 27.05.2024.
//

import Foundation

/// Содержит полную инфу
public struct Teacher: Hashable {
    var fullName: String
    var lessonsUrlEndpoint: String
    var sessionEventsUrlEndpoint: String
    
    var departmentFullName: String?
    var profileImageUrl: URL?
    var email: String?
    var officeAddress: String?
    var workPhoneNumber: String?
    var personalPhoneNumber: String?
    var birthdate: Date?
    
    init(
        fullName: String,
        lessonsUrlEndpoint: String,
        sessionEventsUrlEndpoint: String,
        departmentFullName: String? = nil,
        profileImageUrl: URL? = nil,
        email: String? = nil,
        officeAddress: String? = nil,
        workPhoneNumber: String? = nil,
        personalPhoneNumber: String? = nil,
        birthdate: Date? = nil
    ) {
        self.fullName = fullName
        self.lessonsUrlEndpoint = lessonsUrlEndpoint
        self.sessionEventsUrlEndpoint = sessionEventsUrlEndpoint
        
        self.departmentFullName = departmentFullName
        self.profileImageUrl = profileImageUrl
        self.email = email
        self.officeAddress = officeAddress
        self.workPhoneNumber = workPhoneNumber
        self.personalPhoneNumber = personalPhoneNumber
        self.birthdate = birthdate
    }
    
    public static var mock: Self {
        .init(fullName: "Пример ФИО", lessonsUrlEndpoint: "", sessionEventsUrlEndpoint: "")
    }
}
