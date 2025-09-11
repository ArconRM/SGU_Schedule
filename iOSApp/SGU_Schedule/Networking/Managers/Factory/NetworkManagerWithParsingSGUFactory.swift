//
//  NetworkManagerWithParsingSGUFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 06.02.2025.
//

import Foundation
import SguParser

final class NetworkManagerWithParsingSGUFactory: NetworkManagerFactory {
    private let urlSource = URLSourceSGU()

    func makeLessonsNetworkManager() -> any LessonNetworkManager {
        return LessonNetworkManagerWithParsing(
            urlSource: urlSource,
            lessonParser: LessonHTMLParserSGU(),
            scraper: StaticScraper()
        )
    }

    func makeGroupsNetworkManager() -> any GroupsNetworkManager {
        return GroupsNetworkManagerWithParsing(
            urlSource: urlSource,
            groupsParser: GroupsHTMLParserSGU(),
            scraper: StaticScraper()
        )
    }

    func makeSessionEventsNetworkManager() -> any SessionEventsNetworkManager {
        return SessionEventsNetworkManagerWithParsing(
            urlSource: urlSource,
            sessionEventsParser: SessionEventsHTMLParserSGU(),
            scraper: DynamicScraper()
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
