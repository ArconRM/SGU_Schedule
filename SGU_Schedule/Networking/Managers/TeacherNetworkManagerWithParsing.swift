//
//  TeacherNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 27.05.2024.
//

import Foundation

// Только для нового сайта
public class TeacherNetworkManagerWithParsing: TeacherNetworkManager {
    private var scraper: Scraper
    
    private let urlSource = URLSourceSGU()
    private let urlSourceOld = URLSourceSGU_old()
    private let parser = TeacherHTMLParserSGU()
    private let parserOld = TeacherHTMLParserSGU_old()
    
    init(scraper: Scraper) {
        self.scraper = scraper
    }
    
    public func getTeacher(
        teacherEndpoint: String,
        resultQueue: DispatchQueue = .main,
        completionHandler: @escaping (Result<Teacher, any Error>) -> Void
    ) {
        let teacherUrl = urlSourceOld.getBaseTeacherURL(teacherEndPoint: teacherEndpoint)
        
        do {
            try self.scraper.scrapeUrl(teacherUrl, needToWaitLonger: false) { html in
                do {
                    let teacher = try self.parserOld.getTeacherFromSource(source: html ?? "")
                    
                    resultQueue.async { completionHandler(.success(teacher)) }
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
    
    public func getAllTeachers(
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<Set<TeacherSearchResult>, any Error>) -> Void
    ) {
        let url = URLSourceSGU().getBaseScheduleURL(departmentCode: "")
        
        do {
            try self.scraper.scrapeUrl(url, needToWaitLonger: false) { html in
                do {
                    let teachers = try self.parser.getAllTeachersDTOFromSource(source: html ?? "")
                    
                    resultQueue.async { completionHandler(.success(teachers)) }
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
