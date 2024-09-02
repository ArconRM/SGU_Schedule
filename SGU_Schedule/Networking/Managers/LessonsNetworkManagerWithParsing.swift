//
//  LessonNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Артемий on 23.09.2023.
//

import Foundation
//https://developer.apple.com/forums/thread/729462

public class LessonNetworkManagerWithParsing: LessonNetworkManager {
    private let urlSource: URLSource
    private let lessonParser: LessonHTMLParser
    private let scraper: Scraper
    
    public init(urlSource: URLSource, lessonParser: LessonHTMLParser, scraper: Scraper) {
        self.urlSource = urlSource
        self.lessonParser = lessonParser
        self.scraper = scraper
    }
    
    public func getGroupScheduleForCurrentWeek(
        group: GroupDTO,
        departmentCode: String,
        resultQueue: DispatchQueue = .main,
        completionHandler: @escaping (Result<GroupScheduleDTO, Error>) -> Void
    ) {
        let groupScheduleUrl = urlSource.getGroupScheduleURL(departmentCode: departmentCode, groupNumber:group.fullNumber)
        
        do {
            try self.scraper.scrapeUrl(groupScheduleUrl) { html in
                do {
                    let lessons = try self.lessonParser.getGroupScheduleFromSource(
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
            resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
        }
    }
    
    public func getTeacherScheduleForCurrentWeek(
        teacher: TeacherDTO,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<[LessonDTO], any Error>) -> Void
    ) {
        guard let _ = teacher.teacherLessonsEndpoint else { return }
        let teacherLessonsUrl = urlSource.getBaseTeacherURL(teacherEndPoint: teacher.teacherLessonsEndpoint!)
        
        URLSession.shared.dataTask(with: teacherLessonsUrl as URL) { data, _, error in
            guard error == nil else {
                resultQueue.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: teacherLessonsUrl, encoding: .utf8)
                let lessons = try self.lessonParser.getScheduleFromSource(source: html)
                
                resultQueue.async {
                    completionHandler(.success(lessons))
                }
            }
            catch {
                resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
            }
        }.resume()
    }
}
