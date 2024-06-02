//
//  LessonNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Артемий on 23.09.2023.
//

import Foundation
//https://developer.apple.com/forums/thread/729462

public class LessonNetworkManagerWithParsing: LessonNetworkManager {
    private var urlSource: URLSource
    private var lessonParser: LessonHTMLParser
    
    public init(urlSource: URLSource, lessonParser: LessonHTMLParser) {
        self.urlSource = urlSource
        self.lessonParser = lessonParser
    }
    
    public func getHTML(group: GroupDTO, 
                        resultQueue: DispatchQueue = .main,
                        completionHandler: @escaping(Result<String, Error>) -> Void) { // для теста
        let groupURL = urlSource.getScheduleUrlWithGroupParameter(parameter: String(group.fullNumber))
        
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
    
    public func getGroupScheduleForCurrentWeek(group: GroupDTO, 
                                               resultQueue: DispatchQueue = .main,
                                               completionHandler: @escaping (Result<GroupScheduleDTO, Error>) -> Void) {
        let groupURL = urlSource.getScheduleUrlWithGroupParameter(parameter: String(group.fullNumber))
        
        URLSession.shared.dataTask(with: groupURL as URL) { data, _, error in
            guard error == nil else {
                resultQueue.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: groupURL, encoding: .utf8)
                let lessons = try self.lessonParser.getGroupScheduleFromSource(source: html, groupNumber: group.fullNumber)
                
                resultQueue.async {
                    completionHandler(.success(lessons))
                }
            }
            catch {
                resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
            }
        }.resume()
    }
    
    public func getTeacherScheduleForCurrentWeek(teacher: TeacherDTO, 
                                                 resultQueue: DispatchQueue,
                                                 completionHandler: @escaping (Result<[LessonDTO], any Error>) -> Void) {
        guard let _ = teacher.teacherLessonsEndpoint else { return }
        guard let teacherLessonsUrl = URL(string: urlSource.baseString + teacher.teacherLessonsEndpoint!) else { return }
                                  
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
