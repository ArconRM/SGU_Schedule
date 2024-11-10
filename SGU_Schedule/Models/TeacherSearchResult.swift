//
//  TeacherSearchResult.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 10.11.2024.
//

import Foundation

/// Содержит только основную инфу, которую можно с поиска выцепить
public struct TeacherSearchResult: Hashable, Codable {
    var fullName: String
    var lessonsUrlEndpoint: String
    var sessionEventsUrlEndpoint: String
    
    init(
        fullName: String,
        lessonsUrlEndpoint: String,
        sessionEventsUrlEndpoint: String
    ) {
        self.fullName = fullName
        self.lessonsUrlEndpoint = lessonsUrlEndpoint
        self.sessionEventsUrlEndpoint = sessionEventsUrlEndpoint
    }
    
    public static var mock: Self {
        .init(fullName: "Пример ФИО", lessonsUrlEndpoint: "", sessionEventsUrlEndpoint: "")
    }
}
