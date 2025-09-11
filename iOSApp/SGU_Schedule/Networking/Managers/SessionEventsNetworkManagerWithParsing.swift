//
//  SessionEventsNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation

/// С новым сайтом нужен DynamicScraper
class SessionEventsNetworkManagerWithParsing: SessionEventsNetworkManager {
    private var urlSource: URLSource
    private var sessionEventsParser: SessionEventsHTMLParser
    private let scraper: Scraper

    public init(urlSource: URLSource, sessionEventsParser: SessionEventsHTMLParser, scraper: Scraper) {
        self.urlSource = urlSource
        self.sessionEventsParser = sessionEventsParser
        self.scraper = scraper
    }

    public func getGroupSessionEvents(
        group: AcademicGroupDTO,
        resultQueue: DispatchQueue = .main,
        completionHandler: @escaping (Result<GroupSessionEventsDTO, Error>) -> Void
    ) {
        let groupScheduleUrl = urlSource.getGroupScheduleURL(departmentCode: group.departmentCode, groupNumber: group.fullNumber)
        self.scraper.scrapeUrl(groupScheduleUrl) { html in
            do {
                let sessionEvents = try self.sessionEventsParser.getGroupSessionEventsFromSource(
                    source: html ?? "",
                    groupNumber: group.fullNumber,
                    departmentCode: group.departmentCode
                )

                resultQueue.async { completionHandler(.success(sessionEvents)) }
            } catch {
                resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
            }
        }
    }

    public func getTeacherSessionEvents(
        teacherEndpoint: String?,
        resultQueue: DispatchQueue = .main,
        completionHandler: @escaping (Result<[SessionEventDTO], any Error>) -> Void
    ) {
        guard teacherEndpoint != nil else { return }

        let teacherLessonsUrl = urlSource.getBaseTeacherURL(teacherEndPoint: teacherEndpoint!)
        self.scraper.scrapeUrl(teacherLessonsUrl) { html in
            do {
                let lessons = try self.sessionEventsParser.getSessionEventsFromSource(source: html ?? "")

                resultQueue.async { completionHandler(.success(lessons)) }
            } catch {
                resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
            }
        }
    }
}
