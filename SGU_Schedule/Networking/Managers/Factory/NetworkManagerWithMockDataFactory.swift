//
//  NetworkManagerWithMockDataFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 06.02.2025.
//

import Foundation

final class NetworkManagerWithMockDataFactory: NetworkManagerFactory {
    private let urlSource = URLSourceSGU()

    func makeLessonsNetworkManager() -> any LessonNetworkManager {
        return LessonNetworkManagerWithParsing(
            urlSource: urlSource,
            lessonParser: LessonParserMock(),
            scraper: ScraperMock()
        )
    }

    func makeGroupsNetworkManager() -> any GroupsNetworkManager {
        return GroupsNetworkManagerWithParsing(
            urlSource: urlSource,
            groupsParser: GroupsParserMock(),
            scraper: ScraperMock()
        )
    }

    func makeSessionEventsNetworkManager() -> any SessionEventsNetworkManager {
        return SessionEventsNetworkManagerWithParsing(
            urlSource: urlSource,
            sessionEventsParser: SessionEventsParserMock(),
            scraper: ScraperMock()
        )
    }

    func makeTeacherNetworkManager() -> any TeacherNetworkManager {
        return TeacherNetworkManagerWithParsing(
            urlSource: URLSourceSGU(),
            urlSourceOld: URLSourceSGU_old(),
            parser: TeacherParserMock(),
            parserOld: TeacherParserMock(),
            scraper: ScraperMock()
        )
    }
}
