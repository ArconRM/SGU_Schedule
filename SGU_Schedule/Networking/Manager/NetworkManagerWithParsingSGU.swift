//
//  ScheduleNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Артемий on 23.09.2023.
//

import Foundation
//https://developer.apple.com/forums/thread/729462

public struct NetworkManagerWithParsingSGU: NetworkManagerWithParsing {
    
    public var urlResource: URLSource
    var htmlParser = LessonHTMLParser()
    
    public init(endPoint: URLSource) {
        self.urlResource = endPoint
    }
    
    
    public func getHTML(group: Group, completionHandler: @escaping(Result<String, Error>) -> Void) {
        let groupURL = urlResource.getFullUrlWithParameter(parameter: String(group.FullNumber))
        
        URLSession.shared.dataTask(with: groupURL as URL) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: groupURL, encoding: .utf8)
                DispatchQueue.main.async {
                    completionHandler(.success(html))
                }
            }
            catch {
                DispatchQueue.main.async { completionHandler(.failure(NetworkError.NetworkManagerError)) }
            }
            
        }.resume()
    }
    
    public func getLastUpdateDate(group: Group, completionHandler: @escaping (Result<Date, Error>) -> Void) {
        let groupURL = urlResource.getFullUrlWithParameter(parameter: String(group.FullNumber))
        
        URLSession.shared.dataTask(with: groupURL as URL) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: groupURL, encoding: .utf8)
                let updateDate = try htmlParser.decodeLastUpdateDate(source: html)
                
                DispatchQueue.main.async { //ToDo: Возможно не всегда нужна главная и лучше передавать очередь в метод
                    completionHandler(.success(updateDate))
                }
            }
            catch {
                DispatchQueue.main.async { completionHandler(.failure(NetworkError.HTMLParserError)) }
            }
        }.resume()
    }
    
    public func getScheduleForDay(group: Group, day: Weekdays, isNumerator: Bool, completionHandler: @escaping (Result<[[Lesson]], Error>) -> Void) {
        let groupURL = urlResource.getFullUrlWithParameter(parameter: String(group.FullNumber))
        
        URLSession.shared.dataTask(with: groupURL as URL) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: groupURL, encoding: .utf8)
                let lessons = try htmlParser.getLessonsByWeekdayFromSource(source: html, dayNumber: day.number, isNumerator: isNumerator)
                
                DispatchQueue.main.async {
                    completionHandler(.success(lessons))
                }
            }
            catch {
                DispatchQueue.main.async { completionHandler(.failure(NetworkError.HTMLParserError)) }
            }
        }.resume()
    }
    
    public func getScheduleForCurrentWeek(group: Group, isNumerator: Bool, completionHandler: @escaping (Result<[[[Lesson]]], Error>) -> Void) {
        let groupURL = urlResource.getFullUrlWithParameter(parameter: String(group.FullNumber))
        
        URLSession.shared.dataTask(with: groupURL as URL) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: groupURL, encoding: .utf8)
                let lessons = try htmlParser.getWeekLessonsFromSource(source: html)
                
                DispatchQueue.main.async {
                    completionHandler(.success(lessons))
                }
            }
            catch {
                DispatchQueue.main.async { completionHandler(.failure(NetworkError.HTMLParserError)) }
            }
        }.resume()
    }
}
