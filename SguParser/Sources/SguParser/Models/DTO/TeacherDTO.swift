//
//  TeacherDTO.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 27.05.2024.
//

import Foundation

/// Содержит полную инфу
public struct TeacherDTO: Hashable {
    public var fullName: String
    public var lessonsUrlEndpoint: String
    public var sessionEventsUrlEndpoint: String

    public var departmentFullName: String?
    public var profileImageUrl: URL?
    public var email: String?
    public var officeAddress: String?
    public var workPhoneNumber: String?
    public var personalPhoneNumber: String?
    public var birthdate: Date?

    public init(
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

    public static var mock: TeacherDTO {
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
