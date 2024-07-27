//
//  SessionEventsNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation

public class SessionEventsNetworkManagerWithParsing: SessionEventsNetworkManager {
    private var urlSource: URLSource
    private var sessionEventsParser: SessionEventsHTMLParser
    
    public init(urlSource: URLSource, sessionEventsParser: SessionEventsHTMLParser) {
        self.urlSource = urlSource
        self.sessionEventsParser = sessionEventsParser
    }
    
    
    public func getGroupSessionEvents(
        group: GroupDTO,
        departmentCode: String,
        resultQueue: DispatchQueue = .main,
        completionHandler: @escaping (Result<GroupSessionEventsDTO, Error>) -> Void
    ) {
        let groupScheduleUrl = urlSource.getGroupScheduleURL(departmentCode: departmentCode, groupNumber:group.fullNumber)
        
        URLSession.shared.dataTask(with: groupScheduleUrl as URL) { data, _, error in
            guard error == nil else {
                resultQueue.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: groupScheduleUrl, encoding: .utf8)
                let lessons = try self.sessionEventsParser.getGroupSessionEventsFromSource(source: html, groupNumber: group.fullNumber)
                
                resultQueue.async {
                    completionHandler(.success(lessons))
                }
            }
            catch {
                resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
            }
        }.resume()
    }
    
    public func getTeacherSessionEvents(
        teacher: TeacherDTO,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<[SessionEventDTO], any Error>) -> Void
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
                let lessons = try self.sessionEventsParser.getSessionEventsFromSource(source: html)
                
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
