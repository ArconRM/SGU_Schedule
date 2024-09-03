//
//  SessionEventsNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation

/// С новым сайтом нужен DynamicScraper
public class SessionEventsNetworkManagerWithParsing: SessionEventsNetworkManager {
    private var urlSource: URLSource
    private var sessionEventsParser: SessionEventsHTMLParser
    private let scraper: Scraper
    
    public init(urlSource: URLSource, sessionEventsParser: SessionEventsHTMLParser, scraper: Scraper) {
        self.urlSource = urlSource
        self.sessionEventsParser = sessionEventsParser
        self.scraper = scraper
    }
    
    public func getGroupSessionEvents (
        group: GroupDTO,
        departmentCode: String,
        resultQueue: DispatchQueue = .main,
        completionHandler: @escaping (Result<GroupSessionEventsDTO, Error>) -> Void
    ) {
        let groupScheduleUrl = urlSource.getGroupScheduleURL(departmentCode: departmentCode, groupNumber:group.fullNumber)
        
        do {
            try self.scraper.scrapeUrl(groupScheduleUrl, needToWaitLonger: false) { html in
                do {
                    let lessons = try self.sessionEventsParser.getGroupSessionEventsFromSource(
                        source: html ?? "",
                        groupNumber: group.fullNumber
                    )
                    
                    resultQueue.async { completionHandler(.success(lessons)) }
                }
                catch {
                    resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
                }
            }
        }
        catch {
            resultQueue.async { completionHandler(.failure(NetworkError.scraperError)) }
        }
    }
    
    public func getTeacherSessionEvents (
        teacher: TeacherDTO,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<[SessionEventDTO], any Error>) -> Void
    ) {
        guard let _ = teacher.teacherLessonsEndpoint else { return }
        let teacherLessonsUrl = urlSource.getBaseTeacherURL(teacherEndPoint: teacher.teacherLessonsEndpoint!)
        
        do {
            try self.scraper.scrapeUrl(teacherLessonsUrl, needToWaitLonger: false) { html in
                do {
                    let html = try String(contentsOf: teacherLessonsUrl, encoding: .utf8)
                    let lessons = try self.sessionEventsParser.getSessionEventsFromSource(source: html)
                    
                    resultQueue.async {
                        completionHandler(.success(lessons))
                    }
                }
                catch {
                    resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
                }
            }
        }
        catch {
            resultQueue.async { completionHandler(.failure(NetworkError.scraperError)) }
        }
    }
}
