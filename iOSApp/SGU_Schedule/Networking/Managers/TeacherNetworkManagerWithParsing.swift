//
//  TeacherNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 27.05.2024.
//

import Foundation

public class TeacherNetworkManagerWithParsing: TeacherNetworkManager {

    private var urlSource: URLSource
    private var urlSourceOld: URLSource
    private var parser: TeacherHTMLParser
    private var parserOld: TeacherHTMLParser
    private var scraper: Scraper

    init(
        urlSource: URLSource,
        urlSourceOld: URLSource,
        parser: TeacherHTMLParser,
        parserOld: TeacherHTMLParser,
        scraper: Scraper
    ) {
        self.urlSource = urlSource
        self.urlSourceOld = urlSourceOld
        self.parser = parser
        self.parserOld = parserOld
        self.scraper = scraper
    }

    /// Только для старого сайта
    public func getTeacher(
        teacherEndpoint: String,
        resultQueue: DispatchQueue = .main,
        completionHandler: @escaping (Result<TeacherDTO, any Error>) -> Void
    ) {
        let teacherUrl = urlSourceOld.getBaseTeacherURL(teacherEndPoint: teacherEndpoint)
        self.scraper.scrapeUrl(teacherUrl) { html in
            do {
                let teacher = try self.parserOld.getTeacherFromSource(source: html ?? "")

                resultQueue.async { completionHandler(.success(teacher)) }
            } catch {
                resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
            }
        }
    }

    /// Только для нового сайта
    public func getAllTeachers(
        resultQueue: DispatchQueue = .main,
        completionHandler: @escaping (Result<Set<TeacherSearchResult>, any Error>) -> Void
    ) {
        let allTeachersUrl = urlSource.getAllTeachersURL()
        self.scraper.scrapeUrl(allTeachersUrl) { html in
            do {
                let teachers = try self.parser.getAllTeacherSearchResultsFromSource(source: html ?? "")

                resultQueue.async { completionHandler(.success(teachers)) }
            } catch {
                resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
            }
        }
    }
}
