//
//  LessonsNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Артемий on 23.09.2023.
//

import Foundation
//https://developer.apple.com/forums/thread/729462

public class LessonsNetworkManagerWithParsing: LessonsNetworkManager {
    
    public var urlSource: URLSource
    private var lessonParser: LessonHTMLParser
    
    public init(urlSource: URLSource, lessonParser: LessonHTMLParser) {
        self.urlSource = urlSource
        self.lessonParser = lessonParser
    }
    
    public func getHTML(group: GroupDTO, resultQueue: DispatchQueue = .main, completionHandler: @escaping(Result<String, Error>) -> Void) { // для теста
        let groupURL = urlSource.getUrlWithGroupParameter(parameter: String(group.fullNumber))
        
        URLSession.shared.dataTask(with: groupURL as URL) { data, _, error in
            guard error == nil else {
                resultQueue.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: groupURL, encoding: .utf8)
                resultQueue.async {
                    completionHandler(.success(html))
                }
            }
            catch {
                resultQueue.async { completionHandler(.failure(NetworkError.networkManagerError)) }
            }
            
        }.resume()
    }
    
    public func getLessonsForDay(group: GroupDTO, day: Weekdays, resultQueue: DispatchQueue = .main, completionHandler: @escaping (Result<[[LessonDTO]], Error>) -> Void) {
        let groupURL = urlSource.getUrlWithGroupParameter(parameter: String(group.fullNumber))
        
        URLSession.shared.dataTask(with: groupURL as URL) { data, _, error in
            guard error == nil else {
                resultQueue.async { completionHandler(.failure(error!)) }
                return
            }
            do {
                let html = try String(contentsOf: groupURL, encoding: .utf8)
                let lessons = try self.lessonParser.getLessonsByDayNumberFromSource(source: html, dayNumber: day.number)
                
                resultQueue.async {
                    completionHandler(.success(lessons))
                }
            }
            catch {
                resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
            }
        }.resume()
    }
    
    public func getLessonsForCurrentWeek(group: GroupDTO, resultQueue: DispatchQueue = .main, completionHandler: @escaping (Result<[[[LessonDTO]]], Error>) -> Void) {
        let groupURL = urlSource.getUrlWithGroupParameter(parameter: String(group.fullNumber))
        
        URLSession.shared.dataTask(with: groupURL as URL) { data, _, error in
            guard error == nil else {
                resultQueue.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: groupURL, encoding: .utf8)
                let lessons = try self.lessonParser.getLessonsOnCurrentWeekFromSource(source: html)
                
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
