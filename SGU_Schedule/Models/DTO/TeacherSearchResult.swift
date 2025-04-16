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

    public static var mock: Self {
        .init(fullName: "Пример ФИО",
              lessonsUrlEndpoint: "/lessons",
              sessionEventsUrlEndpoint: "/session_events")
    }

    public static var mocks: [Self] {
        var result = [Self]()
        for i in 0..<10 {
            result.append(
                .init(
                    fullName: "Пример ФИО \(i)",
                    lessonsUrlEndpoint: "/lessons",
                    sessionEventsUrlEndpoint: "/session_events"
                )
            )
        }
        return result
    }
}
