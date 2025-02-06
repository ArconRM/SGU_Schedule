//
//  NetworkManagerWithParsingSGUFactory_old.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 06.02.2025.
//

import Foundation

final class NetworkManagerWithParsingSGUFactory_old: NetworkManagerFactory {
    private let urlSource = URLSourceSGU_old()

    func makeLessonsNetworkManager() -> any LessonNetworkManager {
        return LessonNetworkManagerWithParsing(
            urlSource: urlSource,
            lessonParser: LessonHTMLParserSGU_old(),
            scraper: StaticScraper()
        )
    }

    func makeGroupsNetworkManager() -> any GroupsNetworkManager {
        return GroupsNetworkManagerWithParsing(
            urlSource: urlSource,
            groupsParser: GroupsHTMLParserSGU_old(),
            scraper: StaticScraper()
        )
    }

    func makeSessionEventsNetworkManager() -> any SessionEventsNetworkManager {
        return SessionEventsNetworkManagerWithParsing(
            urlSource: urlSource,
            sessionEventsParser: SessionEventsHTMLParserSGU_old(),
            scraper: StaticScraper()
        )
    }

    func makeTeacherNetworkManager() -> any TeacherNetworkManager {
        return TeacherNetworkManagerWithParsing(
            urlSource: URLSourceSGU(),
            urlSourceOld: URLSourceSGU_old(),
            parser: TeacherHTMLParserSGU(),
            parserOld: TeacherHTMLParserSGU_old(),
            scraper: StaticScraper()
        )
    }
}
