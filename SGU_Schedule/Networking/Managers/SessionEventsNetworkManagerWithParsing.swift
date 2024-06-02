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
    
    
    public func getGroupSessionEvents(group: GroupDTO, 
                                      resultQueue: DispatchQueue = .main,
                                      completionHandler: @escaping (Result<GroupSessionEventsDTO, Error>) -> Void) {
        let groupURL = urlSource.getScheduleUrlWithGroupParameter(parameter: String(group.fullNumber))
        
        URLSession.shared.dataTask(with: groupURL as URL) { data, _, error in
            guard error == nil else {
                resultQueue.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: groupURL, encoding: .utf8)
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
    
    public func getTeacherSessionEvents(teacher: TeacherDTO, 
                                        resultQueue: DispatchQueue,
                                        completionHandler: @escaping (Result<[SessionEventDTO], any Error>) -> Void) {
        guard let _ = teacher.teacherSessionEventsEndpoint else { return }
        guard let teacherSessionEventsUrl = URL(string: urlSource.baseString + teacher.teacherSessionEventsEndpoint!) else { return }
        
        URLSession.shared.dataTask(with: teacherSessionEventsUrl as URL) { data, _, error in
            guard error == nil else {
                resultQueue.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: teacherSessionEventsUrl, encoding: .utf8)
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
