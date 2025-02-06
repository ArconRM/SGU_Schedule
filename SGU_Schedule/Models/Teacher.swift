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

    public static var mock: Teacher {
        .init(
            fullName: "John Doe",
            lessonsUrlEndpoint: "/lessons",
            sessionEventsUrlEndpoint: "/session_events",
            departmentFullName: "Computer Science Department",
            profileImageUrl: URL(string: "https://example.com/profile-image.jpg"),
            email: "johndoe@example.com",
            officeAddress: "Building A, Room 101",
            workPhoneNumber: "(555) 123-4567",
            personalPhoneNumber: "(555) 987-6543",
            birthdate: DateComponents(calendar: .current, year: 1985, month: 4, day: 1).date!
        )
    }
}
