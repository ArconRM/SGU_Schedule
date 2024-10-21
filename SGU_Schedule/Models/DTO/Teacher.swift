//
//  Teacher.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 27.05.2024.
//

import Foundation

public struct Teacher: Hashable {
    
    var fullName: String
    var profileImageUrl: URL?
    var email: String?
    var officeAddress: String?
    var workPhoneNumber: String?
    var personalPhoneNumber: String?
    var birthdate: Date?
    var teacherLessonsEndpoint: String?
    var teacherSessionEventsEndpoint: String?
    
    init(
        fullName: String,
        profileImageUrl: URL? = nil,
        email: String? = nil,
        officeAddress: String? = nil,
        workPhoneNumber: String? = nil,
        personalPhoneNumber: String? = nil,
        birthdate: Date? = nil,
        teacherLessonsEndpoint: String? = nil,
        teacherSessionEventsEndpoint: String? = nil
    ) {
        self.fullName = fullName
        self.profileImageUrl = profileImageUrl
        self.email = email
        self.officeAddress = officeAddress
        self.workPhoneNumber = workPhoneNumber
        self.personalPhoneNumber = personalPhoneNumber
        self.birthdate = birthdate
        self.teacherLessonsEndpoint = teacherLessonsEndpoint
        self.teacherSessionEventsEndpoint = teacherSessionEventsEndpoint
    }
    
    public static var mock: Self {
        .init(fullName: "Мухаммед Абдуллук")
    }
}
